# General Annotations
Just to guide me through this presentation.

## Data Ingestion

## Data Cleaning and Transformations

### *Dropping Columns*  
First of all, I decided to drop some columns based on following criterias:  
- **Duplicity**: there were repeated columns in the dataset:
    - `remaining_min_1, power_of_shot_1, knockout_match_1, remaining_sec_1, distance_of_shot_1`
- **Relevance**: some columns did not have much relevance due to being control data like primary and foreign keys;
- Although it is some kind of time column, there is no accuracy in the `game_season` column. So I deleted;
- In this specific scenario I discarded the `team_name` column because there were only Manchester United games.
    - A simple note about the context may settle this case.

### *Composite Columns*  
The case of types of shot columns:  
- Although there were a lot of null values in both columns, I kept the `type_of_shot` and `type_of_combined_shot` columns because I saw that they are complementary;
    - So I created a new column in wich the values are always from one or the other.

### *Missing Values*  
- Missing `goal` values were converted to False
<!-- - Missing `game season` values were calculated from `date of game`.
  - Records that did not had `game_season` and `day_of_game` where deleted. -->

### *Inconsistent/Unclassifiable Values*
- Column `range_of_shot` did not match range `distance_of_shot`. So I preferred to use the `distance_of_shot` even if I didn't drop the other one.


# TODO
Lista:  
[v] Estatísticas de gols por partidas eliminatórias  
[v] Gols por chutes na área do pênalti  
[v] Áreas dos chutes  <!-- Profiling -->
[v] Quantidade de chutes por tipo de chute  <!-- Profiling -->
[v] Quantidade de chutes por potência de chute  <!-- Profiling -->
[v] Quantidade de chutes por potência de chute >= 4 ao longo do tempo  
[v] Quantidade de chutes por distância  <!-- Profiling -->
[v] Quantidade de chutes por distância de chute >= 40 ao longo do tempo  
[v] Distância em que fez mais gols  
[v] Gols no último minuto  
[v] Gols por tipo de chute  
[v] Gols nos locais v e y  
[v] Relação entre potência do chute e gol  
[v] Relação entre distância do chute e gol  
[ ] Verificar quantidade de jogos na semana (período que teve mais jogos)  
[ ] Verificar relação entre quantidade de jogos e desempenhos  