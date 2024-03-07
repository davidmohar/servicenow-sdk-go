package internal

import "net/http"

type BaseAuthorizationProvider struct {
	credential Credential
}

func NewBaseAuthorizationProvider(credential Credential) *BaseAuthorizationProvider {
	return &BaseAuthorizationProvider{
		credential: credential,
	}
}

func (b *BaseAuthorizationProvider) AuthorizeRequest(request RequestInformation) error {
	headerString, err := b.credential.GetAuthentication()
	if err != nil {
		return err
	}

	newHeaders := http.Header{}
	newHeaders.Set(authorizationHeader, headerString)

	err = request.AddHeaders(newHeaders)
	if err != nil {
		return err
	}

	return nil
}
