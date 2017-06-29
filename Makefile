NAME = bin/Configuration.42r
GAR = Configuration.gar
WAR = Configuration.war
MANIFEST = bin/MANIFEST

YELLOW = @tput setaf 3;
RED = @tput setaf 1;
GREEN = @tput setaf 2;
BLUE = @tput setaf 4;
WHITE = @tput setaf 256;

SRC = src/global.4gl \
			src/customization.4gl \
			src/initialValue.4gl \
			src/locales.4gl \
			src/resources.4gl \
			src/REST.4gl \
			src/main.4gl

FORM = src/Theme.4fd

MODULES = $(SRC:.4gl=.42m)
FORMS = $(FORM:.4fd=.42f)

# Build rules
#--------------------------------------------------#
all: help war

gar: $(NAME)
	@cp MANIFEST bin/MANIFEST
	@fglgar gar Configuration
	@mv $(GAR) dist/
	${GREEN} echo "dist/Configuration.gar created"

war: gar
	@fglgar war -g  dist/Configuration.gar
	@mv $(WAR) dist/
	${GREEN} echo "dist/Configuration.war created"
	${BLUE} echo "Usage: \n\tgasadmin gar --deploy-archive dist/Configuration.gar\n\tgasadmin gar --enable-archive Configuration\nOr use make deploy rule"

deploy:
	@gasadmin gar --deploy-archive dist/${GAR} && gasadmin gar --enable-archive Configuration
	${GREEN} echo 'Configuration.gar deployed'
	${BLUE} echo "Usage: \n\tGSTWCDIR=`pwd`/webcomponents httpdispatch\n\tOr use make start rule"

start:
	GSTWCDIR=$(shell pwd)/webcomponents httpdispatch

$(NAME): $(MODULES) $(FORMS)
	@fgllink -o $(NAME) $(MODULES)
	@mv *.42m bin
	@cp src/*.42f bin

# Other rules
#--------------------------------------------------#

undeploy:
	@gasadmin gar --disable-archive Configuration && gasadmin gar --undeploy-archive Configuration
	${GREEN} echo 'Configuration.gar undeployed'

clean:
	rm -f $(FORMS) $(MODULES) src/*.err bin/*.42m bin/*.42f bin/MANIFEST src/*.per

fclean:	clean
	rm -f bin/* dist/* $(NAME)

re: fclean all

help:
			$(WHITE) echo "list of rules:"
			$(YELLOW) echo "\tall | gar | war | deploy | undeploy | clean | fclean | re"

# Compilation rules
#--------------------------------------------------#
%.42m: %.4gl
	@fglcomp $<
	@cp `echo $* | sed -r 's/^.{4}//'`.42m src

%.42f: %.4fd
	echo 'compile .per'
	@gsform -M -i -keep $*
	@fglform -M $*

#--------------------------------------------------#
