# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A GTK+ graphical interactive version of nec2c"
HOMEPAGE="http://www.qsl.net/5b4az/pages/nec2.html"
SRC_URI="http://www.qsl.net/5b4az/pkg/nec2/xnec2c/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	glib-gettextize --force --copy || die
	eautoreconf
}

src_install() {
	default

	dodoc AUTHORS README doc/*.txt
	use doc && dohtml -r doc/*.html doc/images
	insinto /usr/share/doc/${PF}/examples
	use examples && doins examples/*
}
