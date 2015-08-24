# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools python

MY_P=${PN}${PV%.*.*}-${PV}

DESCRIPTION="a binary diff and differential compression tools. VCDIFF (RFC 3284) delta compression"
HOMEPAGE="http://xdelta.org/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="examples test"

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}
	test? ( || ( dev-lang/python:2.7 dev-lang/python:2.6 ) )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use test; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	>py-compile

	# huh
	sed -i -e '/python/s:2.6:2:' testing/xdelta3-regtest.py || die
	sed -i -e '/python/s:2.7:2:' testing/xdelta3-test.py || die

	# only build tests when required
	sed -i -e '/xdelta3regtest/s:noinst_P:check_P:' Makefile.am || die
	eautoreconf
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
