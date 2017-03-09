# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils eutils

MY_PN="TkDND"

DESCRIPTION="Extension that adds native drag & drop capabilities to the tk toolkit"
HOMEPAGE="http://www.ellogon.org/petasis/tcltk-projects/tkdnd/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${MY_PN}%20${PV}/${P/-/}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug threads X"

RESTRICT="test"

DEPEND="dev-lang/tk"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P/-/}

src_prepare() {
	sed \
		-e 's:-O2::g' \
		-e 's:-fomit-frame-pointer::g' \
		-e 's:-pipe::g' \
		-i configure tclconfig/tcl.m4 || die
}

src_configure() {
	local myeconfargs
	use X && myeconfargs+=( --with-x )
	use debug && myeconfargs+=( --with-symbols )
	use threads && myeconfargs+=( --enable-threads )
	autotools-utils_src_configure
}
