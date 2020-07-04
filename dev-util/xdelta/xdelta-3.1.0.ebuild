# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

WANT_AUTOMAKE=1.14
inherit autotools python-any-r1

MY_P=xdelta3-${PV}

DESCRIPTION="Computes changes between binary or text files and creates deltas"
HOMEPAGE="http://xdelta.org/"
SRC_URI="https://github.com/jmacd/xdelta-gpl/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	eapply_user

	# huh
	sed -i -e '/python/s:2.6:2:' testing/xdelta3-regtest.py || die
	sed -i -e '/python/s:2.7:2:' testing/xdelta3-test.py || die

	# only build tests when required
	sed -i -e '/xdelta3regtest/s:noinst_P:check_P:' Makefile.am || die
	eautomake
}

src_test() {
	default
	./xdelta3regtest || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc draft-korn-vcdiff.txt README.md
	use examples && dodoc -r examples
}
