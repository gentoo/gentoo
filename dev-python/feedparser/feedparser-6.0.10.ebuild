# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}
DESCRIPTION="Parse RSS and Atom feeds in Python"
HOMEPAGE="
	https://github.com/kurtmckee/feedparser/
	https://pypi.org/project/feedparser/
"
SRC_URI="
	https://github.com/kurtmckee/feedparser/archive/${MY_PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	dev-python/sgmllib3k[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/feedparser-6.0.8-fix-py3.10.patch"
)

src_prepare() {
	# broken
	rm \
		tests/illformed/chardet/big5.xml \
		tests/illformed/undeclared_namespace.xml || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" tests/runtests.py -v || die "Tests failed with ${EPYTHON}"
}
