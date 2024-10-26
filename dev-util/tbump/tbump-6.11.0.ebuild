# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="tbump helps you bump the version of your project easily"
HOMEPAGE="https://github.com/your-tools/tbump/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/your-tools/tbump.git"
else
	inherit pypi

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/cli-ui[${PYTHON_USEDEP}]
	dev-python/schema[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	"tbump/test/test_api.py"
	"tbump/test/test_cli.py"
	"tbump/test/test_file_bumper.py::test_file_bumper_preserve_endings"
	"tbump/test/test_file_bumper.py::test_file_bumper_simple"
	"tbump/test/test_git_bumper.py"
	"tbump/test/test_hooks.py"
	"tbump/test/test_init.py"
)

distutils_enable_tests pytest
