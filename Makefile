CXX = g++
CXXFLAGS = -Wall -Werror -Wextra -pedantic -std=c++17 -g -fsanitize=address
LDFLAGS =  -fsanitize=address

SRC = 
OBJ = $(SRC:.cc=.o)
EXEC = Makefile

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CXX) $(LDFLAGS) -o $@ $(OBJ) $(LBLIBS)

clean:
	rm -rf $(OBJ) $(EXEC)

gen:
	sqitch.git -schema ./schema/schema.yml

deploy_stag:
	sqitch-deploy -config-file config.staging.yml -schema schema/schema.yml

deploy_prod:
	sqitch-deploy -config-file config.prod.yml -schema schema/schema.yml