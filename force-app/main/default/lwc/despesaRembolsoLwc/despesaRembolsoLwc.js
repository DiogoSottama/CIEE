import { LightningElement, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import buscarDados from "@salesforce/apex/AprovacaoDespesasReembolsosController.buscarDados";
import aprovarDespesaReembolso from "@salesforce/apex/AprovacaoDespesasReembolsosController.aprovarDespesaReembolso";
import reprovarDespesaReembolso from "@salesforce/apex/AprovacaoDespesasReembolsosController.reprovarDespesaReembolso";

const COLUMN_SCHEMA = [
    {
        label: "Nome",
        fieldName: "link",
        type: "url",
        typeAttributes: {
            label: { fieldName: "Name" },
            target: "_blank"
        }
    },
    {
        label: "Data",
        fieldName: "Data_da_Visita__c",
        type: "date",
        typeAttributes: {
            year: "2-digit",
            month: "2-digit",
            day: "2-digit"
        },
        sortable: "true"
    },
    {
        label: "Hora inicial",
        fieldName: "Hora_da_Visita__c",
        type: "date",
        typeAttributes: {
            hour: "2-digit",
            minute: "2-digit"
        },
        sortable: "true"
    },
    {
        label: "Duração",
        fieldName: "Duracao_da_Visita__c",
        type: "number",
        sortable: "true"
    },
    {
        label: "Empresa",
        fieldName: "Nome_da_Empresa__c",
        type: "text",
        sortable: "true"
    },
    {
        label: "KM",
        fieldName: "Km__c",
        type: "number",
        sortable: true,
        cellAttributes: { alignment: "left" }
    },
    {
        label: "Valor KM",
        fieldName: "Valor_do_Reembolso_de_KM__c",
        type: "number",
        sortable: true,
        cellAttributes: { alignment: "left" }
    }
];

export default class DespesaRembolsoLwc extends LightningElement {
    rows;
    columns = COLUMN_SCHEMA;
    despesaList;

    isLoading = true;

    isEscolhido = false;

    isModal = false;

    filtroCriador = "Todos";

    textoModal = "";

    disableButton = true;

    @track motivoRecusa = "";

    @track selectOptions = [];

    nomeRecusa = "";


    
    optionsCriador = [{ label: "Todos", value: "Todos" }];

    get isModalOpen() {
        return this.isModal;
    }

    get UsuarioEscolhido() {
        return this.isEscolhido;
    }

    get isReprovado() {
        return this.textoModal === "Reprovado" ? true : false;
    }

    get hasRows() {
        return !this.isLoading && !!this.rows && !!this.rows.length;
    }

    @wire(buscarDados, {
        criador: "$filtroCriador"
    })
    carregaDespesas({ error, data }) {
        this.isLoading = true;
        let options = [{ label: "Todos", value: "Todos" }];
        let optione = [];
        if (data) {
            console.log(JSON.parse(JSON.stringify(data, null, 4)));

            this.rows = [
                ...data.map((row, index) => ({
                    ...row,
                    link: `/${row.Id}`,
                    rowNumber: index + 1,
                    sobjectType: "Despesa_e_Reembolso__c"
                }))
            ];

            console.log(JSON.parse(JSON.stringify(this.rows, null, 4)));

            data.forEach((r) => {
                if (!options.find((e) => e.value === r.Nome_do_Consultor__c)) {
                    options.push({
                        label: r.Nome_do_Consultor__c,
                        value: r.Nome_do_Consultor__c
                    });

                }
                optione.push({
                    label: r.Name,
                    value: r.Name
                });
            });




            options.sort((a, b) => a - b);

            this.optionsCriador = options;
            this.selectOptions = optione;
        }

        if (error) {
            console.error(error);
        }

        this.isLoading = false;
        this.disableButton = !this.hasRows;
    }

    handleChange(event) {
        this[event.target.name] = event.detail.value;
        
        if (this.filtroCriador !== "Todos") {
            this.isEscolhido = true;
        } else {
            this.isEscolhido = false;
        }
    }

    async clickAprovar() {
        console.log(JSON.parse(JSON.stringify(this.rows, null, 4)));

        try {
            await aprovarDespesaReembolso({ despesas: this.rows });
            this.isModal = true;
            this.textoModal = "Aprovado";
        } catch (error) {
            console.error(error);
        }
        window.location.reload(true);
    }

    clickReprovar() {
        console.log(JSON.parse(JSON.stringify(this.rows, null, 4)));
        
        this.isModal = true;
        this.textoModal = "Reprovado";
    }

    async closeModal() {
        if (this.textoModal === "Reprovado") {
            if (!this.motivoRecusa) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Motivo Recusa é obrigatório",
                        variant: "error"
                    })
                );
                return;
            }

        if (!this.nomeRecusa) {
            this.dispatchEvent(
                new ShowToastEvent({
                     title: "Nome da despesa recusada é obrigatório",
                    variant: "error"
                })
            );
            return;
        }    

            console.log(JSON.parse(JSON.stringify(this.rows, null, 4)));

            try {
                await reprovarDespesaReembolso({ despesas: this.rows, motivo: this.motivoRecusa, despesaNameRecusa: this.nomeRecusa });
            } catch (error) {
                console.error(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!",
                        message: error,
                        variant: "error"
                    })
                );
            }
            window.location.reload(true);
        }

        this.backModal();
    }

    backModal() {
        this.isModal = false;
    }
}