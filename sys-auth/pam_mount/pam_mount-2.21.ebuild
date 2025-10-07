# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="A PAM module that can mount volumes for a user session"
HOMEPAGE="https://inai.de/projects/pam_mount/"
SRC_URI="https://inai.de/files/pam_mount/${P}.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="crypt ssl selinux"

DEPEND="
	>=sys-libs/pam-0.99
	>=sys-libs/libhx-5.0:=
	>=sys-apps/util-linux-2.20:=
	>=dev-libs/libxml2-2.6:=
	dev-libs/libpcre2
	crypt? ( >=sys-fs/cryptsetup-1.1.0:= )
	ssl? ( dev-libs/openssl:0= )
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig
	$(unpacker_src_uri_depends)"

src_configure() {
	econf --with-slibdir="/$(get_libdir)" \
			$(use_with crypt cryptsetup) \
			$(use_with ssl crypto) \
			$(use_with selinux)
}

src_install() {
	default
	use selinux || rm -r "${D}"/etc/selinux
	dodoc doc/*.txt

	find "${ED}" -name '*.la' -delete || die
}
