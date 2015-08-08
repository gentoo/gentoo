# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base

DESCRIPTION="An HTTP authentication brute forcer"
HOMEPAGE="http://www.divineinvasion.net/authforce/"
SRC_URI="http://www.divineinvasion.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="curl nls"

DEPEND="
	sys-libs/readline
	curl? ( net-misc/curl )
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO )
PATCHES=(
		"${FILESDIR}"/${P}-curl.patch
		"${FILESDIR}"/${P}-locale.patch
		)

src_configure() {
	econf \
		$(use_with curl) \
		$(use_enable nls) \
		--with-path=/usr/share/${PN}/data:.
}
