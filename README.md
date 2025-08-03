# Social Capital and Political Participation – A Cross-National Analysis

This repository contains a term paper written during my Bachelor's studies. It explores how welfare state characteristics influence the relationship between social capital and political participation, using cross-national data from the European Social Survey (ESS Round 9). Multilevel modeling is used to analyze data from 22 countries.

## 📄 Paper

- `does-social-capital-drive-participation`: The full term paper (in German)
- Written in [Social Sciences / Humboldt-Universität zu Berlin]
- Semester: [e.g. Summer Term 2022]

## 📊 Data & Methodology

- **Dataset**: European Social Survey (ESS Round 9, 2018/19)
- **Sample**: 22 European countries
- **Method**: Multilevel regression models
- **Key variables**:
  - *Independent*: Individual-level social capital
  - *Contextual*: Welfare regime types, social spending
  - *Dependent*: Political participation (formal & informal)

## 📌 Research Questions

1. How is individual social capital related to political participation?
2. Does the welfare state context affect this relationship?
3. Are there cross-level interactions between social capital and contextual variables?

## 🔍 Key Findings

- Social capital has a significant positive effect on political participation.
- No consistent evidence that welfare state types or social spending moderate this effect.
- Possible limitations due to operationalization of welfare state dimensions.

## 📁 Folder Structure

This project is organized to enable reproducible analysis using Stata.

- `inputs/` – Raw datasets (ESS, social expenditure, etc.)
- `jobs/` – All Stata scripts (main: `master.do`)
- `outputs/` – Cleaned data, merged datasets
- `results/` – Graphs and regression output
- `logs/` – Execution logs from Stata

To reproduce the analysis, run `jobs/master.do` from the root folder.

## 📚 Citation

If you use or refer to this project, please cite as follows:

> Okonkwo, Kevin (2023). *Welchen Einfluss hat der Wohlfahrtsstaat auf die Beziehung zwischen Sozialkapital und politischer Teilhabe? Eine Untersuchung anhand des European Social Surveys Round 9*. Term Thesis, Humboldt University of Berlin, Department of Social Sciences.

For questions or collaboration, feel free to contact: kevin.ikenna.okonkwo@gmail.com
