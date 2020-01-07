# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="LibVNCServer-${PV}"
DESCRIPTION="library for creating vnc servers"
HOMEPAGE="https://libvnc.github.io/"
SRC_URI="https://github.com/LibVNC/${PN}/archive/${MY_P}.tar.gz"

# libvncserver/tightvnc-filetransfer/*: GPL-2, but we don't build it
# common/d3des.*: https://github.com/LibVNC/libvncserver/issues/88
LICENSE="GPL-2+ LGPL-2.1+ BSD MIT"
# no sub slot wanted (yet), see #578958
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="+24bpp gcrypt gnutls ipv6 +jpeg libressl lzo +png sasl ssl systemd +threads +zlib"
# https://bugs.gentoo.org/690202
# https://bugs.gentoo.org/435326
# https://bugs.gentoo.org/550916
REQUIRED_USE="jpeg? ( zlib ) png? ( zlib ) ssl? ( !gnutls? ( threads ) )"

DEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0= )
	ssl? (
		!gnutls? (
			!libressl? ( >=dev-libs/openssl-1.0.2:0= )
			libressl? ( >=dev-libs/libressl-2.7.0:0= )
		)
		gnutls? ( >=net-libs/gnutls-2.12.23-r6:0= )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	lzo? ( dev-libs/lzo )
	png? ( >=media-libs/libpng-1.6.10:0= )
	sasl? ( dev-libs/cyrus-sasl )
	systemd? ( sys-apps/systemd:= )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_P}"

DOCS=( AUTHORS ChangeLog NEWS README.md TODO )

PATCHES=(
	"${FILESDIR}"/${P}-cmake-libdir.patch
	"${FILESDIR}"/${P}-pkgconfig-libdir.patch
	"${FILESDIR}"/${P}-libgcrypt.patch
	"${FILESDIR}"/${P}-sparc-unaligned.patch
	"${FILESDIR}"/${P}-CVE-2018-20750.patch
	"${FILESDIR}"/${P}-CVE-2019-15681.patch
	"${FILESDIR}"/${P}-fix-tight-raw-decoding.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_ZLIB=$(usex zlib ON OFF)
		-DWITH_LZO=$(usex lzo ON OFF)
		-DWITH_JPEG=$(usex jpeg ON OFF)
		-DWITH_PNG=$(usex png ON OFF)
		-DWITH_THREADS=$(usex threads ON OFF)
		-DWITH_GNUTLS=$(usex gnutls $(usex ssl ON OFF) OFF)
		-DWITH_OPENSSL=$(usex gnutls OFF $(usex ssl ON OFF))
		-DWITH_GCRYPT=$(usex gcrypt ON OFF)
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
		-DWITH_FFMPEG=OFF
		-DWITH_24BPP=$(usex 24bpp ON OFF)
		-DWITH_IPv6=$(usex ipv6 ON OFF)
		-DWITH_SASL=$(usex sasl ON OFF)
	)
	cmake_src_configure
}
