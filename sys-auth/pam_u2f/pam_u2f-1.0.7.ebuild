# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pam

DESCRIPTION="Library for authenticating against PAM with a Yubikey"
HOMEPAGE="https://github.com/Yubico/pam-u2f"
SRC_URI="https://developers.yubico.com/${PN/_/-}/Releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-crypt/libu2f-host
	app-crypt/libu2f-server:=
	sys-libs/pam"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.0.2-fix-Makefile.patch" )

src_prepare() {
	default
	use debug || append-cppflags -UDEBUG_PAM -UPAM_DEBUG
	eautoreconf
}

src_configure() {
	econf --with-pam-dir=$(getpam_mod_dir)
}
