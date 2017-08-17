# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_LINGUAS="de es fr it nb no pl"
QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="An easy to use WYSIWYG CD cover printer with CDDB support"
HOMEPAGE="http://lisas.de/kover/"
SRC_URI="http://lisas.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	dev-libs/libcdio-paranoia
	media-libs/libcddb
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

PATCHES=( "${FILESDIR}/${PN}-4-cflags.patch" )
