# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit desktop optfeature wxwidgets xdg

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="https://sourceforge.net/projects/gspiceui/"
#SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
MY_REV="382"
# SF source is temporal
#SRC_URI="https://sourceforge.net/code-snapshots/svn/g/gs/${PN}/code/${PN}-code-r${MY_REV}-trunk.zip -> ${P}.zip"
SRC_URI="https://dev.gentoo.org/~pacho/${PN}/${PN}-code-r${MY_REV}-trunk.zip -> ${P}.zip"
S="${WORKDIR}/${PN}-code-r${MY_REV}-trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
BDEPEND="app-arch/unzip"

PATCHES=(
	# Use Gentoo LDFLAGS and CXXFLAGS
	# https://sourceforge.net/p/gspiceui/bugs/30/
	"${FILESDIR}"/${P}-respect-users-flags.patch
)

src_configure() {
	setup-wxwidgets
	default
}

src_compile() {
	export HOME="${T}"
	mkdir -p "${T}/.config"
	emake GSPICEUI_WXLIB=3.2 GSPICEUI_DEBUG=0
}

src_install() {
	dobin bin/gspiceui

	einstalldocs
	dodoc html/*.html html/*.jpg html/*.png
	dodoc ChangeLog ReadMe ToDo
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
