# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://github.com/linux-nfc/neard"
SRC_URI="https://github.com/linux-nfc/neard/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test tools systemd"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.28
	dev-libs/libnl:3=
	>=sys-apps/dbus-1.2
	systemd? ( sys-apps/systemd:0 )
"

DEPEND="${RDEPEND}"
BDEPEND="dev-build/autoconf-archive"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-optimization
		--disable-test	# Only installs test programs, #913709.
		--enable-ese
		--enable-nfctype1
		--enable-nfctype2
		--enable-nfctype3
		--enable-nfctype4
		--enable-nfctype5
		--enable-p2p
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
	mv "${ED}/usr/include/version.h" "${ED}/usr/include/near/" || die

	newinitd "${FILESDIR}/neard.rc" neard
	newconfd "${FILESDIR}/neard.confd" neard
}
