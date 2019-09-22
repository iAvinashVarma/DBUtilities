# DB Utilities

Generic MSSQL Database related queries, to improve productivity.

![apm](https://img.shields.io/apm/l/vim-mode.svg)
[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/iAvinashVarma) [![Twitter Follow](https://img.shields.io/twitter/follow/iAvinashVarma.svg?style=social&label=Follow)](https://twitter.com/iAvinashVarma)
![GitHub followers](https://img.shields.io/github/followers/iAvinashVarma.svg?style=flat-square&label=Follow)
[![Feature Requests](https://img.shields.io/github/issues/iAvinashVarma/DBUtilities/feature-request.svg)](https://github.com/iAvinashVarma/DBUtilities/issues?q=is%3Aopen+is%3Aissue+label%3Afeature-request+sort%3Areactions-%2B1-desc)
[![Bugs](https://img.shields.io/github/issues/iAvinashVarma/DBUtilities/bug.svg)](https://github.com/iAvinashVarma/DBUtilities/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Abug)
![Top Language](https://img.shields.io/github/languages/top/iAvinashVarma/DBUtilities.svg?style=flat)

## Run SQLCMD

```cmd
> sqlcmd -E -S . -d GenericRepository -i "E:\Practice\SQLServer\DBUtilities\Scripts\00003_ReadVersionAndInsertIntoApplicationVersion.sql" -v versionfile="E:\Practice\SQLServer\DBUtilities\Others\version.ini"
> sqlcmd -E -S . -d GenericRepository -i "E:\Practice\SQLServer\DBUtilities\Scripts\00003_ReadVersionAndInsertIntoApplicationVersion.sql" -v versionfile="E:\Practice\SQLServer\DBUtilities\Others\version.ini" description="E:\Practice\SQLServer\DBUtilities\Others\description.log"
> sqlcmd -E -S . -d GenericRepository -i "E:\Practice\SQLServer\DBUtilities\Scripts\00004_ReadXmlAndUpdateApplicationVersion.sql" -v applicationxml="E:\Practice\SQLServer\DBUtilities\Others\Application.xml"
```