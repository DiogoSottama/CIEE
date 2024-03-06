public with sharing class KairosDTO {
    public class ClientCredentialsDTO {
        public String token;
    }

    public class RetrieveAllAccountsDTO{
        public List<AccountDTO> content;
		public Integer totalPages;
    }

    public class AccountDTO{
		public Integer id;
		public String companyName;
		public String name;
		public String cnpj;
		public String cpf;
		public String tradingName;
		public String corporateSegment;
		public String state;
		public String cei;
		public String statusRegionalCouncil;
		public String companyType;
		public String statusCompany;
		public Integer employees;
        public Integer serviceContractors;
        public Boolean isClassCouncilActive;
		public String tipoEntidade;
		public Integer chaveObjeto;
		public String codigoObjeto;
    }

	public class RetrieveContractDTO{
		public List<ContractDTOP> content;
		public Integer totalPages;
	}

	public class ContractDTOP{
		public Decimal Id;
		public Integer cieeUnitId;
		public Integer managementId;
		public String cnpj;
		public String cpf;
	}
}