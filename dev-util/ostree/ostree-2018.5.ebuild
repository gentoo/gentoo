# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Operating system and container binary deployment and upgrades"
HOMEPAGE="https://ostree.readthedocs.io/en/latest/"
SRC_URI="https://github.com/ostreedev/${PN}/releases/download/v${PV}/lib${P}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="grub selinux soup systemd zeroconf"
RESTRICT="test"

S="${WORKDIR}/lib${P}"
COMMON_DEPEND="
	app-arch/libarchive:=
	app-arch/xz-utils:=
	app-crypt/gpgme:=
	dev-libs/glib:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	dev-libs/openssl:0=
	net-misc/curl:=
	sys-apps/util-linux:=
	sys-fs/fuse:=
	sys-libs/zlib:=

	grub? ( sys-boot/grub:* )
	selinux? ( sys-libs/libselinux:= )
	soup? ( net-libs/libsoup:= )
	systemd? ( sys-apps/systemd:= )
	zeroconf? ( net-dns/avahi:* )
"
DEPEND="
	${COMMON_DEPEND}
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	unset ${!XDG_*} #657346 g-ir-scanner sandbox violation
	econf \
		--with-crypto=openssl \
		--with-curl \
		--with-openssl \
		$(use_with soup) \
		$(use_with selinux ) \
		$(use_with zeroconf avahi)
}
