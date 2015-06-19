# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-fbterm/ibus-fbterm-0.9.1.ebuild,v 1.3 2014/08/10 17:47:54 slyfox Exp $

EAPI="4"
inherit autotools-utils

DESCRIPTION="ibus-fbterm is a input method for FbTerm based on iBus"
HOMEPAGE="http://ibus-fbterm.googlecode.com"
SRC_URI="https://ibus-fbterm.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/ibus-1.4.1
	app-i18n/fbterm"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-ibus-1.4.1.patch
	"${FILESDIR}"/${P}-ibus-1.4.99.patch
)
