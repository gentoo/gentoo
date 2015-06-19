# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/growl-for-linux/growl-for-linux-0.6.7.ebuild,v 1.1 2013/02/16 17:50:15 tomwij Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Growl Implementation For Linux"
HOMEPAGE="http://mattn.github.com/growl-for-linux/"
SRC_URI="mirror://github/mattn/growl-for-linux/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-db/sqlite:3
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl
	net-misc/curl
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local myeconfargs=(
		LIBS=-lgthread-2.0
		--disable-static
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --modules
}
