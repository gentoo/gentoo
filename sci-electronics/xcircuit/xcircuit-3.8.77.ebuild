# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/xcircuit/xcircuit-3.8.77.ebuild,v 1.2 2015/03/20 15:25:12 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils multilib

DESCRIPTION="Circuit drawing and schematic capture program"
SRC_URI="http://opencircuitdesign.com/xcircuit/archive/${P}.tgz"
HOMEPAGE="http://opencircuitdesign.com/xcircuit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	app-text/ghostscript-gpl
	dev-lang/tk:0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXpm
	x11-libs/libSM
	x11-libs/libICE"
RDEPEND=${DEPEND}

RESTRICT="test" #131024

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	# automake-1.12
	sed \
		-e '/AM_C_PROTOTYPES/d' \
		-i configure.in || die
	# automake-1.13
	mv configure.{in,ac} || die
	autotools-utils_src_prepare
}

src_configure() {
	export loader_run_path="/usr/$(get_libdir)"
	local myeconfargs=(
		--disable-dependency-tracking
		--with-tcl
		--with-ngspice
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile appdefaultsdir="/usr/share/X11/app-defaults"
}

src_install () {
	autotools-utils_src_install \
		appdefaultsdir="/usr/share/X11/app-defaults" \
		appmandir="/usr/share/man/man1"
}
