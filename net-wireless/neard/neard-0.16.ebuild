# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://01.org/linux-nfc/"
SRC_URI="https://www.kernel.org/pub/linux/network/nfc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="tools systemd"

RDEPEND="
	 dev-libs/libnl:3=
	 sys-apps/dbus
	 sys-libs/glibc
	 systemd? ( sys-apps/systemd:0 )
"

DEPEND="${RDEPEND}"

src_configure() {
	 # Workaround for >= GCC-10
	 append-cflags -fcommon

	 local myeconfargs=(
		  --disable-optimization
		  --enable-ese
		  --enable-pie
		  $(use_enable systemd)
		  $(use_enable tools)
	 )
	 econf "${myeconfargs[@]}"
}

src_install() {
	 default

	 # Patch for this has been sent upstream.  Do it manually
	 # to avoid having to rebuild autotools. #580876
	 mv "${ED}"/usr/include/version.h "${ED}"/usr/include/near/ || die

	 newinitd "${FILESDIR}"/neard.rc neard
	 newconfd "${FILESDIR}"/neard.confd neard
}
