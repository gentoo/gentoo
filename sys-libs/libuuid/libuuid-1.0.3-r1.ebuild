# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Portable uuid C library"
HOMEPAGE="https://libuuid.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x64-solaris"

DEPEND="!!sys-apps/util-linux
	!!sys-libs/native-uuid"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	elibtoolize
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
