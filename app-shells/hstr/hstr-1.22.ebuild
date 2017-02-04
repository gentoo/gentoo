# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="shell history suggest box"
HOMEPAGE="https://github.com/dvorka/hstr http://www.mindforger.com"
SRC_URI="https://github.com/dvorka/hstr/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-libs/ncurses:0="

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=( CONFIGURATION.md README.md )

src_prepare() {
	default
	sed \
		-e 's:-O2::g' \
		-i src/Makefile.am || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
}
