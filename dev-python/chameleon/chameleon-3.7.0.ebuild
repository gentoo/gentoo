# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Fast HTML/XML template compiler for Python"
HOMEPAGE="https://github.com/malthe/chameleon
	https://pypi.org/project/Chameleon/"
SRC_URI="
	https://github.com/malthe/chameleon/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 ~x86"

distutils_enable_tests setup.py
