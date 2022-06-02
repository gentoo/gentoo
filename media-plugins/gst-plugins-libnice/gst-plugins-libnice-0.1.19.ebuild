# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson-multilib

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
MY_P=libnice-${PV}
SRC_URI="https://nice.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	~net-libs/libnice-${PV}[${MULTILIB_USEDEP}]
	media-libs/gstreamer:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/gst-plugins-libnice-0.1.18-use-installed-libnice.patch
)

S=${WORKDIR}/${MY_P}

multilib_src_configure() {
	# gnutls vs openssl left intentionally automagic here - the chosen USE flag configuration of libnice will ensure
	# one of them is present, configure will be happy, but gstreamer bits don't use it, so it doesn't matter.
	# gupnp is not used in the gst plugin.
	local emesonargs=(
		-Dgstreamer=enabled
		-Dcrypto-library=auto
		-Dintrospection=disabled
		-Dgupnp=disabled
	)

	meson_src_configure
}
