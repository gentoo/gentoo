# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Produce ansi color output and colored highlighting and diffing"
HOMEPAGE="https://github.com/numerodix/ansicolor https://pypi.org/project/ansicolor/"
SRC_URI="
	https://github.com/numerodix/ansicolor/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
