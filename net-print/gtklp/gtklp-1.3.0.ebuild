# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A GUI for cupsd"
HOMEPAGE="http://gtklp.sirtobi.com/"
SRC_URI="mirror://sourceforge/gtklp/${P}.src.tar.gz
	mirror://sourceforge/gtklp/logo.xpm.gz -> gtklp-logo.xpm.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls ssl"

RDEPEND="x11-libs/gtk+:2
	>=net-print/cups-1.6
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog README TODO USAGE"

src_prepare() {
	sed -e '/DEF_BROWSER_CMD/{s:netscape:firefox:}' \
		-e '/DEF_HELP_HOME/{s:631/sum.html#STANDARD_OPTIONS:631/help/:}' \
		-i include/defaults.h || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable ssl) \
		--enable-forte #369003
}

src_install () {
	default

	doicon "${WORKDIR}"/gtklp-logo.xpm
	make_desktop_entry 'gtklp -i' "Print files via CUPS" gtklp-logo 'System;HardwareSettings;Settings;Printing'
	make_desktop_entry gtklpq "CUPS queue manager" gtklp-logo 'System;HardwareSettings;Settings;Printing'
}
