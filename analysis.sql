USE SCHEMA CS_CHALLENGE_DB.CS_DATA;
ALTER SESSION SET WEEK_OF_YEAR_POLICY = 1;
ALTER SESSION SET WEEK_START = 7;

/* Goal Stats by [Knockout] Matches */
WITH GOALS_BY_KM AS (
    SELECT
        MATCH_ID,
        CASE KNOCKOUT_MATCH
            WHEN FALSE THEN 'NO'
            WHEN TRUE THEN 'YES'
        END KNOCKOUT_MATCH,
        SUM(IS_GOAL) GOALS
    FROM GAMES_SILVER
    WHERE KNOCKOUT_MATCH IS NOT NULL
    GROUP BY MATCH_ID, KNOCKOUT_MATCH
)
SELECT
    KNOCKOUT_MATCH,
    min(GOALS) MIN_GOALS,
    max(GOALS) MAX_GOALS,
    ROUND(avg(GOALS)) AVG_GOALS,
    median(GOALS) MEDIAN_GOALS
FROM GOALS_BY_KM
GROUP BY KNOCKOUT_MATCH
;

/* Shots at Penalty's Spot Efficiency */
WITH PENALTY_SPOT AS (
    SELECT
        CASE IS_GOAL WHEN FALSE THEN 1 END GOAL,
        CASE IS_GOAL WHEN TRUE THEN 1 END NOT_GOAL
    FROM GAMES_SILVER
    WHERE upper(SHOT_BASICS) = 'PENALTY SPOT'
    AND IS_GOAL IS NOT NULL
)
SELECT
    SUM(GOAL) GOALS,
    SUM(NOT_GOAL) NOT_GOALS,
    SUM(GOAL) + SUM(NOT_GOAL) TOTAL,
    ROUND(SUM(GOAL) / (SUM(GOAL) + SUM(NOT_GOAL)) * 100, 2) EFFICIENCY
FROM PENALTY_SPOT
;

/* Area of shots */
SELECT
    AREA_OF_SHOT,
    COUNT(*) SHOTS
FROM GAMES_SILVER
GROUP BY AREA_OF_SHOT
;

/* Distance of shots >= 40 over time */
SELECT
    trunc(DATE_OF_GAME, 'MONTH') MONTH_YEAR,
    COUNT(*) SHOTS
FROM GAMES_SILVER
WHERE DATE_OF_GAME IS NOT NULL
AND DISTANCE_OF_SHOT >= 40
GROUP BY
    trunc(DATE_OF_GAME, 'MONTH')
;

/* Power of shots >= 4 over time */
SELECT
    trunc(DATE_OF_GAME, 'MONTH') MONTH_YEAR,
    COUNT(*) SHOTS
FROM GAMES_SILVER
WHERE DATE_OF_GAME IS NOT NULL
AND POWER_OF_SHOT >= 4
GROUP BY
    trunc(DATE_OF_GAME, 'MONTH')
;

/* Goals over distance of shot */
SELECT
    DISTANCE_OF_SHOT,
    COUNT(*) GOALS
FROM GAMES_SILVER
WHERE IS_GOAL = 1
AND DISTANCE_OF_SHOT IS NOT NULL
GROUP BY
    DISTANCE_OF_SHOT
ORDER BY 2 DESC
LIMIT 5
;

/* Goals with 1-10 minutes remaining for the end of the match */
WITH GOALS AS (
SELECT
    CASE WHEN REMAINING_MIN <= 1 THEN COUNT(1) END REMAINING_1,
    CASE WHEN REMAINING_MIN BETWEEN 2 AND 5 THEN COUNT(1) END REMAINING_2_5,
    CASE WHEN REMAINING_MIN BETWEEN 6 AND 10 THEN COUNT(1) END REMAINING_10
FROM GAMES_SILVER
WHERE IS_GOAL = 1
AND REMAINING_MIN <= 10
GROUP BY REMAINING_MIN
)
SELECT
    SUM(REMAINING_1) REMAINING_1,
    SUM(REMAINING_2_5) REMAINING_2_5,
    SUM(REMAINING_10) REMAINING_10
FROM GOALS
;

/* Goals over type of shot */
SELECT
    NORMALIZED_TYPE_OF_SHOT,
    COUNT(*)
FROM GAMES_SILVER
WHERE IS_GOAL = 1
GROUP BY NORMALIZED_TYPE_OF_SHOT
ORDER BY 2 DESC
LIMIT 5
;

/* Locations where goals were done */
SELECT
    LOCATION_X,
    LOCATION_Y,
    COUNT(*) GOALS
FROM GAMES_SILVER
WHERE IS_GOAL = 1
AND LOCATION_X IS NOT NULL
AND LOCATION_Y IS NOT NULL
GROUP BY
    LOCATION_X,
    LOCATION_Y
ORDER BY 3 DESC
;

/* Power of shot X Goals */
SELECT
    POWER_OF_SHOT,
    COUNT(*) GOALS
FROM GAMES_SILVER
WHERE IS_GOAL = 1
AND POWER_OF_SHOT IS NOT NULL
GROUP BY POWER_OF_SHOT
ORDER BY 2 DESC
;

/* Distance of shot X Goals */
SELECT
    DISTANCE_OF_SHOT,
    COUNT(*) GOALS
FROM GAMES_SILVER
WHERE IS_GOAL = 1
AND DISTANCE_OF_SHOT IS NOT NULL
GROUP BY DISTANCE_OF_SHOT
ORDER BY 2 DESC
;

/* Relation between matches per week and goals */
SET YEAR_OF_GAME = 2016;

SELECT
    weekofyear(DATE_OF_GAME) WEEK_OF_YEAR,
    COUNT(DISTINCT MATCH_ID) MATCHES,
    SUM(IS_GOAL) GOALS,
    ROUND(SUM(IS_GOAL) / COUNT(DISTINCT MATCH_ID), 2) MEAN_OF_GOALS
FROM GAMES_SILVER
WHERE YEAR_OF_GAME = $YEAR_OF_GAME
GROUP BY
    weekofyear(DATE_OF_GAME)
ORDER BY weekofyear(DATE_OF_GAME)
;