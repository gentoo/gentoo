# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi-otr/irssi-otr-1.0.0.ebuild,v 1.3 2015/04/26 16:24:41 pacho Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Off-The-Record messaging (OTR) for irssi"
HOMEPAGE="https://github.com/cryptodotis/irssi-otr"
SRC_URI="https://github.com/cryptodotis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc x86"
IUSE=""

# please note >=libotr-4.1.0 is required due to critical bugfix
# d748757e581b74e7298df155ad49174cb914102b, see README.md
RDEPEND="
	>=dev-libs/glib-2.22.0:2
	>=dev-libs/libgcrypt-1.2.0:0
	>=net-libs/libotr-4.1.0
	>=net-irc/irssi-0.8.15[perl]"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF="yes"
DOCS=( README.md )
PATCHES=( "${FILESDIR}/${P}-cflags.patch" )
