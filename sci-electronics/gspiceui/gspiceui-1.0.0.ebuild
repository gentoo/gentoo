# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

WX_GTK_VER="2.8"
inherit eutils wxwidgets

MY_P="${PN}-v${PV}0"

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="http://www.geda.seul.org/tools/gspiceui/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples schematics waveform"

DEPEND="x11-libs/wxGTK:2.8[X]
	sci-electronics/electronics-menu"
RDEPEND="${DEPEND}
	|| ( sci-electronics/ngspice sci-electronics/gnucap )
	waveform? ( sci-electronics/gwave )
	schematics? ( sci-electronics/geda )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Use Gentoo LDFLAGS and CXXFLAGS
	epatch "${FILESDIR}/${P}-flags.patch"

	# Adjusting the doc path at src/main/HelpTasks.cpp
	sed -i -e \
		"s:/share/gspiceui/html/User-Manual.html:/share/doc/${PF}/html/User-Manual.html:g" \
		src/main/HelpTasks.cpp || die
}

src_install() {
	dobin bin/gspiceui || die
	dodoc ChangeLog ReadMe ToDo || die
	doman gspiceui.1 || die
	newicon src/icons/gspiceui-48x48.xpm gspiceui.xpm || die

	dohtml html/*.html html/*.jpg || die

	# installing examples and according model and symbol files
	if use examples ; then
		insinto /usr/share/doc/${PF}/sch
		doins -r sch/* || die
		insinto /usr/share/doc/${PF}/lib
		doins -r lib/* || die
	fi

	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui "Electronics"
}

pkg_postinst() {
	if use examples ; then
		elog "If you want to use the examples, copy from"
		elog "/usr/share/doc/${PF} the sch and lib directory"
		elog "side by side to your home directory to be able"
		elog "to generate the netlists as normal user."
	fi
}
