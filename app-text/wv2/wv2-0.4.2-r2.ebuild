# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Excellent MS Word filter lib, used in most Office suites"
HOMEPAGE="http://wvware.sourceforge.net"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="zlib"

RDEPEND="dev-libs/glib
	>=gnome-extra/libgsf-1.8:=
	virtual/libiconv
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README RELEASE THANKS TODO )
PATCHES=(
	"${FILESDIR}/${P}-glib.patch"
	"${FILESDIR}/${P}-libgsf.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with zlib)
	)
	cmake-utils_src_configure
}
