# PostgreSQL
[postgres_tables.aml](./postgres_tables.aml)
## Part I - Users
- Media flags:

| D2 | D1 | D0 | Flag Name                | Flag            |
|----|----|----|--------------------------|-----------------|
| 0  | 0  | 0  | No Tag                   | NONE            |
| 0  | 0  | 1  | Profile Picture          | PROFILE         |
| 1  | 0  | 1  | Profile Picture (Current)| PROFILE_CURRENT |
| 0  | 1  | 0  | Cover Picture            | COVER           |
| 1  | 1  | 0  | Cover Picture (Current)  | COVER_CURRENT   |


