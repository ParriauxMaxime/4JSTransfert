.PHONY: $(GLOBAL)

NAME = bin/configuration.42r
GAR = configuration.gar
WAR = configuration.war
MANIFEST = bin/MANIFEST
XCF = configuration.xcf


YELLOW = @tput setaf 3;
RED = @tput setaf 1;
GREEN = @tput setaf 2;
BLUE = @tput setaf 4;
WHITE = @tput setaf 256;

GLOBAL = src/global.4gl

SRC = 	src/customization.4gl \
	src/initialValue.4gl \
	src/locales.4gl \
	src/resources.4gl \
	src/REST.4gl \
	src/validator.4gl \
	src/main.4gl

FORM = src/Theme.4fd

MODULES = $(SRC:.4gl=.42m)
FORMS = $(FORM:.4fd=.42f)

# Build rules
#--------------------------------------------------#
all: help war

gar: $(NAME)
	@cp MANIFEST bin/MANIFEST
	@fglgar gar configuration
	@mkdir -p dist
	@mv $(GAR) dist/
	${GREEN} echo "dist/configuration.gar created"
	${WHITE}

war: gar
	@fglgar war -g  dist/configuration.gar
	@mv $(WAR) dist/
	${GREEN} echo "dist/configuration.war created"
	${BLUE} echo "Usage: \n\tgasadmin gar --deploy-archive dist/configuration.gar\n\tgasadmin gar --enable-archive configuration\nOr use make deploy rule"
	${WHITE}

deploy:
	@gasadmin gar --deploy-archive dist/${GAR} && gasadmin gar --enable-archive configuration
	${GREEN} echo 'configuration.gar deployed'
	${BLUE} echo "Usage: \n\tGSTWCDIR=`pwd`/webcomponents httpdispatch\n\tOr use make start rule"
	${WHITE}

start:
	cp $(FGLASDIR)/etc/as.xcf .
	sed -i 's/$(res.fgldir)\/bin\/fglrun/$(res.fgldir)\/bin\/fglrun --java-option=-Xss2m/g' as.xcf
	@GSTWCDIR=$(shell pwd)/webcomponents httpdispatch -f ./as.xcf

auto-start: $(NAME) gar deploy start

restart: undeploy re deploy start

$(XCF):
	@echo "<?xml version='1.0' encoding='UTF-8' ?>\n\t \
		<APPLICATION Parent='defaultgwc' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='http://www.4js.com/ns/gas/3.00/cfextwa.xsd'>\n\t \
	  <EXECUTION>\n\t \
	    <PATH>$(shell pwd)/bin</PATH>\n\t \
	    <MODULE>configuration.42r</MODULE>\n\t \
	    <WEB_COMPONENT_DIRECTORY>$(shell pwd)/webcomponents</WEB_COMPONENT_DIRECTORY>\n\t \
	  </EXECUTION>\n\t \
	</APPLICATION>" > configuration.xcf
	$(GREEN) echo "$(XCF) file created at `pwd`"
	$(WHITE)

$(NAME): $(XCF) global $(MODULES) $(FORMS)
	@mkdir -p bin
	@fgllink -o $(NAME) $(MODULES)
	@mv *.42m bin
	@cp src/*.42f bin
	@rm global.4gl

global:
	@cp src/global.4gl ./global.4gl

# Other rules
#--------------------------------------------------#

undeploy:
	@gasadmin gar --disable-archive configuration && gasadmin gar --undeploy-archive configuration
	${GREEN} echo 'configuration.gar undeployed'
	$(WHITE)

clean:
	rm -f $(FORMS) $(MODULES) src/*.err *.42m global.4gl

fclean:	clean
	rm -f bin/* dist/* $(NAME) *.xcf

re: fclean all

help:
	$(WHITE) echo "list of rules:"
	$(YELLOW) echo "\tall | gar | war | deploy | undeploy | start | clean | fclean | re\n\tUse auto-start for getting started"
	$(WHITE)

# Compilation rules
#--------------------------------------------------#
%.42m: %.4gl
	@fglcomp --java-option=-Xss2m $<  #Ugly java-option allow IMPORT JAVA to not SEGV
	@cp `echo $* | cut -c 5-`.42m src

%.42f: %.4fd
	@gsform -M -i -keep $*
	@fglform -M $*

#--------------------------------------------------#
