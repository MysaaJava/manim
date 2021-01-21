

### TODO add missing commands 
### TODO add install-deps, based on os (apt/dnf/snap …)


# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
	$(strip \
		$(foreach 1,$1, \
			$(call __check_defined,$1,$(strip $(value 2))) \
		) \
	)
__check_defined = \
	$(if $(value $1), \
		, \
		$(error Undefined $1$(if $2, ($2))$(if $(value @), required by target '$@')) \
	)


.PHONY: install-precommit-hooks install-prepush-hooks install-hook test check black docs-html clean help list list-targets install package pip-package choco-package

### This part tries to detect the dev environnement you are using

# If poetry is installed and configured for this directory
POETRY_EXECUTABLE := $(shell command -v poetry 2> /dev/null)
ifdef POETRY_EXECUTABLE
POETRY_USABLE := $(shell poetry env list)
endif


# NOTE: We suppose that if we run on a poetry shell, the user want to use the python module
RUN_AS_SHELL=$(or $(POETRY_ACTIVE),$(if $(strip $(POETRY_USABLE)),,do))


# runCommandOrModule 1:commandName 2:args 3:moduleNameIfDifferentFromCommandName
runCommandOrModule= \
	$(if $(shell command -v $1 2> /dev/null), \
		$(shell $1 $2 ), \
		$(shell python -m $(if $(strip $3), $3, $1) $2) \
	)
	
# pyrun 1:commandName 2:args 3:moduleNameIfDifferentFromCommandName
pyrun = \
	$(if $(strip $(RUN_AS_SHELL)), \
		$(call runCommandOrModule, $1, $2, $3), \
		$(shell poetry run $1 $2) \
	)

install-hook:
	
	@:$(call check_defined, MANIM_GIT_HOOK_FILE)
	
	if test ! -f  $(MANIM_GIT_HOOK_FILE); then echo "#!$(SHELL)" > $(MANIM_GIT_HOOK_FILE); fi

	echo "" >> $(MANIM_GIT_HOOK_FILE)
	echo "make black" >> $(MANIM_GIT_HOOK_FILE)
	echo "" >> $(MANIM_GIT_HOOK_FILE)
	
	chmod +x $(MANIM_GIT_HOOK_FILE)

install-precommit-hook: MANIM_GIT_HOOK_FILE=.git/hooks/pre-commit
install-precommit-hook: install-hook
	
install-prepush-hook: MANIM_GIT_HOOK_FILE=.git/hooks/pre-push
install-prepush-hook: install-hook
	

test: check
check:
	# Runs pytest in the project root
	
	@:$(call pyrun, pytest)

black:
	# Runs black in the project root
	
	@:$(call pyrun, black, .)

docs-html:
	# Builds the html docs using sphinx
	
	cd docs && $(MAKE) html
	
	
clean:
	# Remove every temporary build or test file in the folder
	git clean -Xf
	cd docs && $(MAKE) clean
	
help:
list:
list-targets:
	# List every target of this makefile with their help text
	


install:
	# Installs the manim package.

package:
	# Creates tar.gz source package.

pip-package:
	# Creates a pip-ready package.

choco-package:
	# Creates a chocolatey-ready package.
