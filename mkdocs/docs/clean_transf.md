# Data Cleaning and Transformations

## *Dropping Columns*  
First of all, I decided to drop some columns based on following criterias:

- **Duplicity**: there were repeated columns in the dataset:  
    * `remaining_min_1, power_of_shot_1, knockout_match_1, remaining_sec_1, distance_of_shot_1`  
- **Relevance**: some columns did not have much relevance due to being control data like primary and foreign keys, except for `match_id`;  
- Although it is some kind of time column, there is no accuracy in the `game_season` column. So I deleted;  
- In this specific scenario I discarded the `team_name` column because there were only Manchester United games.  
    * A simple note about the context may settle this case.

## *Composite/Derived Columns*  
- The types of shot columns:
    * Although there were a lot of null values in both columns, I kept the `type_of_shot` and `type_of_combined_shot` columns because I saw that they are complementary;  
        + So I created a new column in wich the values are always from one or the other.
- I made the `year_of_game` column derived from date_of_game, just to see if were some relation between amount of games in a week and the performance of the player.

## *Inconsistent/Unclassifiable Values*
- Column `range_of_shot` did not match range `distance_of_shot`. So I preferred to use the `distance_of_shot` even if I didn't drop the other one.

## *Missing Values*
This dataset has many missing values.  
The only column with no missing values ​​is the one that identifies a match.