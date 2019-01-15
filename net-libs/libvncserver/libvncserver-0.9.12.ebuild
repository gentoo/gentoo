# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-multilib

MY_PN="LibVNCServer"

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="https://libvnc.github.io/"
SRC_URI="https://github.com/LibVNC/${PN}/archive/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
# No sub slot wanted (yet), see #578958
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+24bpp gcrypt gnutls ipv6 +jpeg libressl lzo +png sasl sdl ssl static-libs systemd test +threads +zlib"
REQUIRED_USE="!gnutls? ( ssl? ( threads ) ) png? ( zlib )"

DEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
	gnutls? (
		>=net-libs/gnutls-2.12.23-r6:0=[${MULTILIB_USEDEP}]
		>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		ssl? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		)
	)
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	lzo? ( dev-libs/lzo )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	sasl? ( dev-libs/cyrus-sasl )
	sdl? ( media-libs/libsdl2 )
	systemd? ( sys-apps/systemd:= )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:0=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PN}-${PV}"

DOCS=( AUTHORS ChangeLog NEWS README.md TODO )

PATCHES=(
	"${FILESDIR}"/${P}-cmake-libdir.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_ZLIB=$(usex zlib ON OFF)
		-DWITH_LZO=$(usex lzo ON OFF)
		-DWITH_JPEG=$(usex jpeg ON OFF)
		-DWITH_PNG=$(usex png ON OFF)
		-DWITH_SDL=$(usex sdl ON OFF)
		-DWITH_THREADS=$(usex threads ON OFF)
		-DWITH_GNUTLS=$(usex gnutls ON OFF)
		-DWITH_OPENSSL=$(usex gnutls OFF $(usex ssl ON OFF))
		-DWITH_GCRYPT=$(usex gnutls ON $(usex gcrypt ON OFF))
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
		-DWITH_FFMPEG=OFF
		-DWITH_24BPP=$(usex 24bpp ON OFF)
		-DWITH_IPv6=$(usex ipv6 ON OFF)
		-DWITH_SASL=$(usex sasl ON OFF)
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
