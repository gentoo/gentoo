# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A PAM module that can mount volumes for a user session"
HOMEPAGE="http://pam-mount.sourceforge.net"
SRC_URI="mirror://sourceforge/pam-mount/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE="crypt ssl selinux"

DEPEND="
	>=sys-libs/pam-0.99
	>=sys-libs/libhx-3.12.1:=
	>=sys-apps/util-linux-2.20:=
	>=dev-libs/libxml2-2.6:=
	dev-libs/libpcre2
	crypt? ( >=sys-fs/cryptsetup-1.1.0:= )
	ssl? ( dev-libs/openssl:0= )
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/pam_mount-2.16-remove-obsolete-openssl-api.patch
)

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

	# Remove unused nonstandard run-dir, current version uses
	# FHS-compatible /run, but has leftover mkdir from old version
	rm -r "${D}/var/lib"

	find "${ED}" -name '*.la' -delete || die
}
