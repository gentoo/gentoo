# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Circuit drawing and schematic capture program"
SRC_URI="http://opencircuitdesign.com/xcircuit/archive/${P}.tgz"
HOMEPAGE="http://opencircuitdesign.com/xcircuit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="tcl"

DEPEND="
	app-text/ghostscript-gpl
	media-libs/fontconfig:1.0=
	sys-libs/zlib:=
	x11-libs/cairo
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXt
	tcl? (
		dev-lang/tcl:0=
		dev-lang/tk:0=
	)
"
RDEPEND="${DEPEND}
	sci-electronics/ngspice"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-cairo
		--with-ngspice
		$(use_with tcl)
		$(use_with tcl tcllibs "/usr/$(get_libdir)")
		$(use_with tcl tk)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
