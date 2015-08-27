# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RESTRICT="test"

DEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2"

RDEPEND="$DEPEND"

src_configure() {
	export HAVE_GCOV_FALSE='#'
	econf $(use_enable debug)
}
