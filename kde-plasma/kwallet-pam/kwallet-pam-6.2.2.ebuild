# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="PAM module to not enter KWallet password again after login"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	>=kde-frameworks/kwallet-${KFMIN}:6
	sys-libs/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:6."
	elog "See also: https://wiki.gentoo.org/wiki/KDE#KWallet_auto-unlocking"
}
