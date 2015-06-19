# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx-cloudpinyin/fcitx-cloudpinyin-0.3.1.ebuild,v 1.5 2015/04/19 11:55:00 blueness Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A fcitx module to look up pinyin candidate words on the internet"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.7
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig"
