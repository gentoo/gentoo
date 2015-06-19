# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-birthday-reminder/pidgin-birthday-reminder-1.7.ebuild,v 1.4 2012/07/09 17:44:46 johu Exp $

EAPI=4

DESCRIPTION="Plugin for Pidgin that reminds you of your buddies birthdays"
HOMEPAGE="http://launchpad.net/pidgin-birthday-reminder"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="net-im/pidgin[gtk]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -delete || die "la removal failed"
	fi
}
