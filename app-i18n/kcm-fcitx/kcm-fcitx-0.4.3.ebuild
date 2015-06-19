# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kcm-fcitx/kcm-fcitx-0.4.3.ebuild,v 1.4 2015/05/01 05:55:34 jer Exp $

EAPI=5
inherit kde4-base

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8[qt4]
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
