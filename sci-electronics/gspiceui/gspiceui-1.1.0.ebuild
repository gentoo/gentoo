# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit desktop flag-o-matic toolchain-funcs wxwidgets

MY_P="${PN}-v${PV}0"

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="https://sourceforge.net/projects/gspiceui/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples schematics waveform"

DEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	sci-electronics/electronics-menu"
RDEPEND="
	${DEPEND}
	|| (
		sci-electronics/ngspice
		sci-electronics/gnucap
	)
	waveform? ( sci-electronics/gwave )
	schematics? ( sci-electronics/geda )"

PATCHES=(
	# Use Gentoo LDFLAGS and CXXFLAGS
	"${FILESDIR}"/${P}-flags.patch
)

src_prepare() {
	default

	# Adjusting the doc path at src/main/HelpTasks.cpp
	sed -i -e \
		"s:/share/gspiceui/html/User-Manual.html:/share/doc/${PF}/html/User-Manual.html:g" \
		src/main/HelpTasks.cpp || die

	# Adjusting call to gwave program
	sed -i -e "s/gwave2/gwave/g" src/TypeDefs.hpp || die
}

src_configure() {
	setup-wxwidgets

	# bug 553968
	replace-flags -O? -O1

	default
}

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	dobin bin/gspiceui

	HTML_DOCS=( html/*.html html/*.jpg html/*.png )
	einstalldocs
	dodoc ChangeLog ReadMe ToDo release-notes-v1.1.00.txt
	doman gspiceui.1

	# installing examples and according model and symbol files
	use examples && dodoc -r lib sch

	newicon src/icons/gspiceui-48x48.xpm gspiceui.xpm
	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui "Electronics"
}

pkg_postinst() {
	if use examples ; then
		elog "If you want to use the examples, copy and extract from"
		elog "${EROOT}/usr/share/doc/${PF} the sch and lib directory"
		elog "side by side to your home directory to be able"
		elog "to generate the netlists as normal user."
	fi
}
