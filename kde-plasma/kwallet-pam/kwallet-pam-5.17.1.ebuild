# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="KWallet PAM module to not enter password again"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kwallet)
	dev-libs/libgcrypt:0=
	sys-libs/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)
	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:5."
	elog "See also: https://wiki.gentoo.org/wiki/KDE#KWallet_auto-unlocking"
}
