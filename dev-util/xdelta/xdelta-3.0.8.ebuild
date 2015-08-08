# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

MY_P=${PN}${PV%.*.*}-${PV}

DESCRIPTION="a binary diff and differential compression tools. VCDIFF (RFC 3284) delta compression"
HOMEPAGE="http://xdelta.org/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples lzma test"

RDEPEND="lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	test? ( || ( dev-lang/python:2.7 dev-lang/python:2.6 ) )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use test; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# huh
	sed -i -e '/python/s:2.6:2:' testing/xdelta3-regtest.py || die
	sed -i -e '/python/s:2.7:2:' testing/xdelta3-test.py || die

	# only build tests when required
	sed -i -e '/xdelta3regtest/s:noinst_P:check_P:' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		ac_cv_header_lzma_h=$(usex lzma) \
		ac_cv_lib_lzma_lzma_easy_buffer_encode=$(usex lzma)
}

src_test() {
	default
	./xdelta3regtest || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc draft-korn-vcdiff.txt README
	use examples && dodoc -r examples
}
