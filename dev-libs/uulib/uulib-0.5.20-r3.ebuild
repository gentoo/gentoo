# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=uudeview-${PV}

DESCRIPTION="Library that supports Base64 (MIME), uuencode, xxencode and binhex coding"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/${P}-libtool.patch # 780018
	"${FILESDIR}"/${PN}-0.5.20-Fix-Wimplicit-function-declaration-for-strerror.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
