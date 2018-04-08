library(dplyr)
library(tidyr)
library(elo)

# Elo ratings extracted from this site 
# http://morehockeystats.com/teams/elo#

# Input files and preparation 
nhl.elo <- read.delim('2018-04-08_nhl_elo.tsv', sep = "\t", check.names = FALSE, as.is=TRUE, header=TRUE)
colnames(nhl.elo)[1] <- 'index'

k.factor <- 24

# Functions
simulate.series <- function(team.elo.a, team.elo.b, team.a, team.b) {
  win.counter <- c(0,0)
  names(win.counter) <- c('a', 'b')
  
  # For home ice advantage
  games.counter <- 1
  a.advantage <- c(1,2,5,7)
  
  while(max(win.counter) != 4) {
    # Add home ice advantage to elo 
    temp.team.elo.a <- team.elo.a
    temp.team.elo.b <- team.elo.b
    if (games.counter %in% a.advantage ) {
      temp.team.elo.a <- team.elo.a + 3
    } else {
      temp.team.elo.b <- team.elo.b + 3
    }
    
    # Calculate winning percentage of team A 
    win.p.a <- elo.prob(temp.team.elo.a, temp.team.elo.b)
    win.test <- rbinom(1 , 1, win.p.a)
    if(win.test == 1) {
      some.winner <- 
      win.vector <- 1
      wins.toadd <- c(1,0)
    } else {
      some.winner <- 'B'
      win.vector <- 0
      wins.toadd <- c(0,1)
    }
    
    win.counter <- win.counter + wins.toadd
    elo.new <- elo.calc(win.vector, team.elo.a, team.elo.b, k.factor)
    team.elo.a <- elo.new[1,1]
    team.elo.b <- elo.new[1,2]
    
  }
  
  # Determine winner and return number of games
  n.games <- sum(win.counter)
  
  winner <- names(which(win.counter == 4))
  if(winner == 'a') {
    winning.team = team.a
  } else {
    winning.team = team.b
  }
  return(c(winning.team, n.games))
}

who.wins <- function(team.a.id, team.b.id, rseed = 12345, n.reps = 1001){
  team.id.a <- team.a.id
  team.id.b <- team.b.id
  
  team.elo.a <- nhl.elo[team.id.a, 'Elo']
  team.elo.b <- nhl.elo[team.id.b, 'Elo']
  
  team.a.name <- nhl.elo[team.id.a, 'Team']
  team.b.name <- nhl.elo[team.id.b, 'Team']
  
  
  
  # Prepare matrix
  sim.output <- data.frame(rep = 1:n.reps, team = NA, games.n = 0)
  set.seed(rseed)
  for (i in 1:n.reps) {
    games.results <- simulate.series(team.elo.a, team.elo.b, team.a.name, team.b.name)
    sim.output[i,] <- c(i, games.results)
  }
  sim.output$games.n <- as.numeric(sim.output$games.n)
  
  t.toparse <- table(sim.output$team)
  
  # Winning team
  winning.team <- names(which(t.toparse == max(t.toparse)))
  winning.percentage <- max(t.toparse) / n.reps 
  games.table <- sim.output %>% 
    filter(team == winning.team) %>%
    group_by(games.n) %>%
    summarize(num.games = n())
  
  max.row <- which(games.table$num.games == max(games.table$num.games))
  num.games <- unlist(games.table[max.row, 1])
  
  cat(paste0('Winning team: ', winning.team, " at ", winning.percentage ,"\n"))
  cat(paste0("Number of games: ", num.games, "\n"))
  
  # return(c(winning.team, num.games))
}
