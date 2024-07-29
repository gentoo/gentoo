# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

MY_PV=$(ver_cut 1-3)
DEB_PV=$(ver_cut 4-5)
DESCRIPTION="Create and edit the partition table of a disk partitioned in Atari format"
HOMEPAGE="https://packages.qa.debian.org/a/atari-fdisk.html"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${MY_PV}-${DEB_PV}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
# Note: The code assumes sizeof(long) == 4 everywhere. 64-bit platforms need to
# build a 32-bit binary below to avoid memory corruption issues.
KEYWORDS="~amd64 ~m68k x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.1.5.4-prompt-logic.patch
	"${FILESDIR}"/${PN}-0.7.1.5.4-gcc-5-inline.patch
	"${FILESDIR}"/${PN}-0.7.1.5.4-globals.patch
)

src_configure() {
	if use amd64; then
		multilib_toolchain_setup x86
	else
		tc-export CC LD
	fi
}

src_compile() {
	emake \
		CC="${CC}" \
		LD="${LD}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		COMPILE_ARCH=m68k
}

src_install() {
	dodoc NEWS README TODO debian/changelog
	doman debian/atari-fdisk.8

	into /
	dosbin atari-fdisk
}
