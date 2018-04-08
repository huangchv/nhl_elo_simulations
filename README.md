# NHL ELO Simulator for Stanley Cup Playoffs 2018

## Introduction
Just for fun, I wanted a less than random way of determining the winners in the brackets. I originally wanted to try a machine learning method of calculating odds ratio, but using ELO values is definitely faster. ELO is probably a bit better because certain teams become more refined as time passes and are more sensitive to streaks, and ELO updates account for large differences in input ELO scores. 

## How it works
There are two functions. Playoff series are capped at seven games. The simulation function takes the ELO and calculates the probability of Team 1 winning the first game, simulate a game, and recalculate the ELO. This is repeated until a team reaches 4 wins to determine the winner of a series, and the number of games. Then this entire process is repeated until the max number of reps. 
There is a helper function that wraps around the simulation function for ease of use. Inputs to the helper function are the team indices, number of reps, and random seed. Function returns the inner of the series, the percent of the simulations that team won, and number of games it most frequently went to. 

# Note
There are plenty of ELO calculators and simulators out there. I am not responsible for the output of the script. I am not also responsible for you using my script for gambling or for anything related to gambling or you losing money because of this script. If you feel that you may have a gambling problem, please see this site: [CAMH](http://www.camh.ca/en/hospital/health_information/a_z_mental_health_and_addiction_information/problemgambling/Pages/default.aspx)