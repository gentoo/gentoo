# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic autotools

DESCRIPTION="Library of assorted C utility functions"
# Was: http://zekiller.skytech.org/coders_en.html
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:0=[sslv3] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-libs.patch"
	"${FILESDIR}/fix-Wformat-security-warnings.patch"
)

src_prepare() {
	default
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in \
		|| die 'failed to rename AM_CONFIG_HEADER macro'

	eautoreconf
}

src_configure() {
	append-flags -D_GNU_SOURCE
	econf $(use_enable ssl)
}
