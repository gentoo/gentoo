# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.102.0
PVCUT=$(ver_cut 1-3)
inherit ecm plasma.kde.org

DESCRIPTION="PAM module to not enter KWallet password again after login"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	>=kde-frameworks/kwallet-${KFMIN}:5
	sys-libs/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:5."
	elog "See also: https://wiki.gentoo.org/wiki/KDE#KWallet_auto-unlocking"
}
