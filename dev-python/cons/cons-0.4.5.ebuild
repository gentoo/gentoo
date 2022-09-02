# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Implementation of Lisp/Scheme-like cons in Python"
HOMEPAGE="
	https://pypi.org/project/cons/
	https://github.com/pythological/python-cons/
"
SRC_URI="
	https://github.com/pythological/python-cons/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="dev-python/logical-unification[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
