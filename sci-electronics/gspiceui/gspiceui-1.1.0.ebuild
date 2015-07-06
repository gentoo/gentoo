# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gspiceui/gspiceui-1.1.0.ebuild,v 1.2 2015/07/06 14:02:19 tomjbe Exp $

EAPI="5"

WX_GTK_VER="3.0"
inherit eutils flag-o-matic toolchain-funcs wxwidgets

MY_P="${PN}-v${PV}0"

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="http://www.geda.seul.org/tools/gspiceui/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples schematics waveform"

DEPEND="x11-libs/wxGTK:3.0[X]
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

	# Adjusting call to gwave program
	sed -i -e "s/gwave2/gwave/g" src/TypeDefs.hpp || die

	# bug 553968
	replace-flags -O? -O1
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	dobin bin/gspiceui
	dodoc ChangeLog ReadMe ToDo release-notes-v1.1.00.txt
	doman gspiceui.1
	newicon src/icons/gspiceui-48x48.xpm gspiceui.xpm

	dohtml html/*.html html/*.jpg html/*.png

	# installing examples and according model and symbol files
	if use examples ; then
		insinto /usr/share/doc/${PF}/sch
		doins -r sch/*
		insinto /usr/share/doc/${PF}/lib
		doins -r lib/*
	fi

	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui "Electronics"
}

pkg_postinst() {
	if use examples ; then
		elog "If you want to use the examples, copy and extract from"
		elog "/usr/share/doc/${PF} the sch and lib directory"
		elog "side by side to your home directory to be able"
		elog "to generate the netlists as normal user."
	fi
}
