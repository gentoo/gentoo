# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://github.com/linux-nfc/neard"
SRC_URI="https://github.com/linux-nfc/neard/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test tools"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.28:2
	dev-libs/libnl:3=
	>=sys-apps/dbus-1.2
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	test? (
		dev-libs/glib:2[introspection]
		dev-libs/gobject-introspection
		dev-python/dbus-python
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20-fix_parallel.patch
)

CONFIG_CHECK="~NFC"

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
		--enable-systemd # Only installs unit
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# Patch for this has been sent upstream.  Do it manually
	# to avoid having to rebuild autotools. #580876
	mv "${ED}/usr/include/version.h" "${ED}/usr/include/near/" || die

	newinitd "${FILESDIR}/neard.init" neard
	newconfd "${FILESDIR}/neard.confd" neard
}
