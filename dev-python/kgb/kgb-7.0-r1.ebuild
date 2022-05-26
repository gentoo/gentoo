# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

MY_P=${PN}-release-${PV}
DESCRIPTION="Python function spy support for unit tests"
HOMEPAGE="
	https://github.com/beanbaginc/kgb/
	https://pypi.org/project/kgb/
"
SRC_URI="
	https://github.com/beanbaginc/kgb/archive/release-${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

src_prepare() {
	# remove .dev tag that breaks revdeps
	sed -i -e '/tag_build/d' setup.cfg || die
	distutils-r1_src_prepare
}
