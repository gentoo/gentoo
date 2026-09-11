# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI=true
KFMIN=6.26.0
inherit ecm plasma.kde.org

DESCRIPTION="PAM module to not enter KWallet password again after login"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	sys-libs/pam
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kwallet-runtime-${KFMIN}:6
	net-misc/socat
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_LIBDIR="/$(get_libdir)"
		-DKWALLETD_BIN_PATH="${EPREFIX}/usr/bin/ksecretd" # source: KF6WalletConfig.cmake
	)
	ecm_src_configure
}

pkg_postinst() {
	elog "This package enables auto-unlocking of kde-frameworks/kwallet-runtime:6."
	elog "See also: https://wiki.gentoo.org/wiki/KDE#KWallet_auto-unlocking"
}
