# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson-multilib

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="https://libnice.freedesktop.org/"
MY_P=libnice-${PV}
SRC_URI="https://libnice.freedesktop.org/releases/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	~net-libs/libnice-${PV}[${MULTILIB_USEDEP}]
	media-libs/gstreamer:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.21-use-installed-libnice.patch
)

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
