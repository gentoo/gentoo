# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pam

DESCRIPTION="PAM module for FIDO2 and U2F keys"
HOMEPAGE="https://github.com/Yubico/pam-u2f"
SRC_URI="https://developers.yubico.com/${PN/_/-}/Releases/${P}.tar.gz"

LICENSE="BSD ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	dev-libs/libfido2:=
	dev-libs/openssl:=
	sys-libs/pam"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use debug || append-cppflags -UDEBUG_PAM -UPAM_DEBUG
	econf --with-pam-dir=$(getpam_mod_dir)
}

src_install() {
	default

	# plugin only
	find "${ED}" -name '*.la' -delete || die
}
