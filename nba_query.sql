--1--
select position, count(*) as count
from players
GROUP BY position;

--2--
select player_regular_season_year
from (select year as player_regular_season_year, sum(gp) as player_regular_season_gp from player_regular_season WHERE team!='TOT' group by year), 
    (select year as player_playoffs_year, sum(gp) as player_playoffs_gp from player_playoffs group by year)
where player_regular_season_year=player_playoffs_year
order by  player_regular_season_gp+player_playoffs_gp desc limit 5;

--3--
ALTER table player_regular_season_career
add column eff as
(pts + reb + asts + stl + blk −
((fga − fgm) +
(fta − ftm) + turnover));
select ilkid
from( select sum(gp) as player_gp, sum(eff) as player_eff, ilkid
  from player_regular_season_career
  group by ilkid)
where player_gp>500
order by player_eff desc limit 10;




--4--
SELECT count(*) from
(select distinct ilkid
from (select sum(gp) as player_gp, ilkid,year from player_regular_season where team!='TOT' group by year,ilkid)
where year="1990" and player_gp > (select gp from (select ilkid as id,max(gp) as gp from (select ilkid,gp from player_regular_season where team!='TOT' and year != "1990") group by ilkid) where ilkid=id));

-- 5 --
select ilkid, firstname, lastname, gp, eff from (select ilkid,firstname,lastname,sum(gp) as gp, sum(eff) as eff from  player_regular_season_career group by ilkid) where gp = (select max(gp) from player_regular_season_career) or eff = (select max(eff) from player_regular_season_career)
order by ilkid asc;

