# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/numerodix/ansicolor.git"
else
	# pypi tars don't include tests and github repo is missing release tags,
	# so only enabling tests for 9999 at this time
	SRC_URI="
	https://github.com/numerodix/ansicolor/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Produce ansi color output and colored highlighting and diffing"
HOMEPAGE="https://github.com/numerodix/ansicolor https://pypi.org/project/ansicolor/"

LICENSE="Apache-2.0"
SLOT="0"

distutils_enable_tests pytest
