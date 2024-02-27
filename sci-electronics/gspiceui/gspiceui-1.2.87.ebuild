# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit desktop optfeature wxwidgets xdg

MY_P="${PN}-v${PV}"

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="https://sourceforge.net/projects/gspiceui/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples"

DEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	sci-electronics/electronics-menu
"
RDEPEND="
	${DEPEND}
	|| (
		sci-electronics/ngspice
		sci-electronics/gnucap
	)
"

PATCHES=(
	# Use Gentoo LDFLAGS and CXXFLAGS
	"${FILESDIR}"/${P}-respect-users-flags.patch
)

src_prepare() {
	default

	# Adjusting the doc path at src/main/FrmHtmlVwr.cpp
	sed -i -e \
		"s:/share/gspiceui/html/User-Manual.html:/share/doc/${PF}/html/User-Manual.html:g" \
		src/main/FrmHtmlVwr.cpp || die
}

src_configure() {
	setup-wxwidgets
	default
}

src_compile() {
	emake
}

src_install() {
	dobin bin/gspiceui

	einstalldocs
	dodoc html/*.html html/*.jpg html/*.png
	dodoc ChangeLog ReadMe ToDo release-notes-v${PV}.txt
	doman gspiceui.1

	# installing examples and according model and symbol files
	use examples && dodoc -r lib sch

	newicon -s 32 src/icons/gspiceui-32x32.xpm gspiceui.xpm
	newicon -s 48 src/icons/gspiceui-48x48.xpm gspiceui.xpm
	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui "Electronics"
}

pkg_postinst() {
	xdg_pkg_postinst
	if use examples ; then
		elog "If you want to use the examples, copy and extract from"
		elog "${EROOT}/usr/share/doc/${PF} the sch and lib directory"
		elog "side by side to your home directory to be able"
		elog "to generate the netlists as normal user."
	fi
	optfeature "schematics editing" sci-electronics/geda
	optfeature "waveform display" sci-electronics/gwave
}
