*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    FakerLibrary


*** Variables ***
${base_url}  http://localhost:5000/api

*** Test Cases ***
Deve retornar uma lista de usuários cadastrados
    create session   mysession          ${base_url}
    ${response}=     GET On Session     mysession  /v1/users

    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}     200

    ${body}=         convert to string  ${response.content}
    should contain   ${body}            UnixUser

Deve cadastrar um novo usuário com sucesso
    create session   mysession          ${base_url}
    ${name}=         FakerLibrary.First Name
    ${email}=        FakerLibrary.Email
    ${header}=       create Dictionary  Content-Type=application/json

    ${response}=     POST On Session    mysession       /v1/users/   data={"name": "${name}", "email": "qa_tmp_${email}", "password": "123456"}  headers=${header}

    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}     201

    ${res_body}=     convert to string  ${response.content}
    should contain   ${res_body}        ${name}
    should contain   ${res_body}        ${email}