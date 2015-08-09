# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Smith charting program, mainly designed for educational use"
HOMEPAGE="http://www.jcoppens.com/soft/linsmith/index.en.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/libxml2:2
	dev-libs/glib:2
	dev-libs/atk
	gnome-base/libgnome
	gnome-base/libgnomecanvas
	gnome-base/libgnomeui"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# This patch is to prevent make install copying
	# the examples in /usr/share/linsmith
	# Now they are cp to the correct location.
	epatch \
		"${FILESDIR}"/${PN}-datafiles.patch

	# fix QA warnings about wrong categories in .desktop file
	sed -i -e "s/Application;Engineering;/Education;Science;Electronics;/" \
		-e "s/Encoding=/#Encoding=/" \
		${PN}.desktop || die

	# fix QA warnings about 'maintainer mode'
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	insinto "/usr/share/${PN}"
	doins datafiles/conv0809

	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO
	doman doc/${PN}.1

	domenu ${PN}.desktop
	doicon ${PN}_icon.xpm

	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins doc/manual.pdf
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins datafiles/*.circ datafiles/*.load || die
	fi
}
