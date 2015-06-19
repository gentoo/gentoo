# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libzrtpcpp/libzrtpcpp-4.2.4.ebuild,v 1.1 2014/09/13 16:24:26 mgorny Exp $

EAPI=5

inherit cmake-utils

MY_P=ZRTPCPP-${PV}

DESCRIPTION="GNU RTP stack for the zrtp protocol developed by Phil Zimmermann"
HOMEPAGE="http://www.gnutelephony.org/index.php/GNU_ZRTP"
# https://github.com/wernerd/ZRTPCPP/releases
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
LICENSE="GPL-3"
IUSE="sqlite"
SLOT="0/4"

RDEPEND="
	dev-libs/openssl:0=
	sqlite? ( dev-db/sqlite:3= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README.md )

S=${WORKDIR}/${MY_P}

src_configure() {
	# note: building only core since that's what ortp wants

	local mycmakeargs=(
		-DCORE_LIB=yes
		-DCRYPTO_STANDALONE=no
		-DSQLITE=$(usex sqlite)
	)

	cmake-utils_src_configure
}
