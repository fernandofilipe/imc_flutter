# Fernando Reis

🎉🎉 Desafio IMC Flutter - **Bootcamp Santander 2023**.

<img src="https://imgur.com/Su998MI.png" alt="octocat" width="200" height="200">

> "Toda a nossa ciência, comparada com a realidade, é primitiva e infantil – e, no entanto, é a coisa mais preciosa que temos." — Albert Einstein

## 📸 Descrição do Desafio
Criar um APP Flutter que cálcula o IMC onde devemos:

* Criar classe IMC (Peso / Altura)​
* Ler dados no app​
* Calcular IMC ​
* Exibir em uma lista

## 🔖 Extras
Durante os estudos para construir o APP coloquei algumas funcionalidades extras, as quais serão listadas abaixo:

* Modo Escuro: Usando o controle de temas e o storage da biblioteca `GETX`.
* Localização: Usando a biblioteca `Intl` para colocar as datas dos datepickers no formato `pt_BR`;
* Cadastro/Lista de usuários: O sistema permite cadastra vários usuários para acompanhamento dos pesos registrados;
* Filtro por data: Os pesos registrados podem ser filtrados através de um `date_picker_timeline` localizado no home;
* Bottom Navigator estilizado: Foi utilizada a biblioteca `curved_navigation_bar` respeitando as cores do tema definido no sistema;
* Modo de edição/deleção de registros: Ao clicar em uma leitura você poderá escolher entre as funcionalidades de edição e deleção
do registro em questão;
* Persistência de dados no SQLite: Os registros de imc e usuários cadastrados são persistidos no SQLite.

## 📚 Bibliografia

* [Curved Navigator](https://pub.dev/packages/curved_navigation_bar)
* [Flutter Typeahead](https://pub.dev/packages/flutter_typeahead)
* [Datepicker Timeline](https://pub.dev/packages/date_picker_timeline)
* [SQLite](https://pub.dev/packages/sqflite)
* [Flutter Localizations](https://pub.dev/packages/flutter_localization)
* [Intl](https://pub.dev/packages/intl)
* [Get Storage](https://pub.dev/packages/flutter_typeahead)
* [Get](https://pub.dev/packages/get)