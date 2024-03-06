// Copyright (c) Alex Tennant
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/**
 * @description This class provides methods for preparing client request.
 */
public class HttpRequestBuilder {
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String CONTENT_TYPE_APPLICATION_JSON = 'application/json';
    public static final String HTTP_METHOD_GET = 'GET';
    public static final String HTTP_METHOD_PATCH = 'PATCH';
    public static final String HTTP_METHOD_POST = 'POST';
    public static final String HTTP_METHOD_PUT = 'PUT';

    private String body;
    private Blob bodyAsBlob;
    private Dom.Document bodyDocument;
    private String certDevName;
    private Boolean flag;
    private String endpoint;
    private Map<String, String> headers = new Map<String, String>();
    private String method;
    private Integer timeout;

    public HttpRequest build() {
        return build(new List<String>());
    }

    public HttpRequest build(List<String> params) {
        HttpRequest req = new HttpRequest();

        if (body != null) {
            req.setBody(body);
        }

        if (bodyAsBlob != null) {
            req.setBodyAsBlob(bodyAsBlob);
        }

        if (bodyDocument != null) {
            req.setBodyDocument(bodyDocument);
        }

        if (timeout != null) {
            req.setTimeout(timeout);
        }

        if (certDevName != null) {
            req.setClientCertificateName(certDevName);
        }

        if (flag != null) {
            req.setCompressed(flag);
        }

        if (endpoint != null) {
            req.setEndpoint(String.format(endPoint, params));
        }

        for (String key : headers.keySet()) {
            req.setHeader(key, headers.get(key));
        }

        if (method != null) {
            req.setMethod(method);
        }

        return req;
    }

    public HttpResponse send() {
        return send(new List<String>());
    }

    public HttpResponse send(List<String> params) {
        return new Http().send(build(params));
    }

    public HttpRequestBuilder get(String endpoint) {
        return setMethod(HTTP_METHOD_GET).setEndpoint(endpoint);
    }

    public HttpRequestBuilder patch(String endpoint) {
        return setMethod(HTTP_METHOD_PATCH).setEndpoint(endpoint);
    }

    public HttpRequestBuilder post(String endpoint) {
        return setMethod(HTTP_METHOD_POST).setEndpoint(endpoint);
    }

    public HttpRequestBuilder put(String endpoint) {
        return setMethod(HTTP_METHOD_PUT).setEndpoint(endpoint);
    }

    public HttpRequestBuilder json(Object data) {
        return json((JSON.serialize(data)));
    }

    public HttpRequestBuilder json(String data) {
        return setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_APPLICATION_JSON).setBody(data);
    }

    public HttpRequestBuilder setBody(String body) {
        this.body = body;
        return this;
    }

    public HttpRequestBuilder setBody(Blob body) {
        this.bodyAsBlob = body;
        return this;
    }

    public HttpRequestBuilder setBody(Dom.Document document) {
        this.bodyDocument = document;
        return this;
    }

    public HttpRequestBuilder setClientCertificateName(String certDevName) {
        this.certDevName = certDevName;
        return this;
    }

    public HttpRequestBuilder setCompressed(Boolean flag) {
        this.flag = flag;
        return this;
    }

    public HttpRequestBuilder setEndpoint(String endpoint) {
        this.endpoint = endpoint;
        return this;
    }

    public HttpRequestBuilder setHeader(String key, String value) {
        this.headers.put(key, value);
        return this;
    }

    public HttpRequestBuilder setHeaders(Map<String, String> headers) {
        this.headers.putAll(headers);
        return this;
    }

    public HttpRequestBuilder setMethod(String method) {
        this.method = method;
        return this;
    }

    public HttpRequestBuilder setTimeout(Integer timeout) {
        this.timeout = timeout;
        return this;
    }
}