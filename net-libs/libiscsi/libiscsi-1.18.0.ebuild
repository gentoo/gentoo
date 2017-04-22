# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"
SRC_URI="https://github.com/sahlberg/libiscsi/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-manpages \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
