

detect-dev-env:
	# Detect which programming/packaging environnement the dev uses.
	# It it then put in the MANIM_DEV_ENV variable as one of the following strings:
	# "poetry","terminal"


install-precommit-hooks:
	# Install precommit hooks at .git/hooks/pre-commit

install-prepush-hooks:
	# Install prepush hooks at .git/hooks/pre-push

test:
check:
	# Runs pytest in the project root

black:
	# Runs black in the project root

docs-html:
	# Builds the html docs using sphinx

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
