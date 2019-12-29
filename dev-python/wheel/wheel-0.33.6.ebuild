# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy pypy3 )

inherit distutils-r1 eutils

DESCRIPTION="A built-package format for Python"
HOMEPAGE="https://pypi.org/project/wheel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/pypa/wheel/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed \
		-e 's:--cov=wheel::g' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}
