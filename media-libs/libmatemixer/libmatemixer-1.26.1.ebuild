# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="Mixer library for MATE Desktop"
LICENSE="LGPL-2+"
SLOT="0"

IUSE="+alsa pulseaudio +udev"
REQUIRED_USE="udev? ( alsa )"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	virtual/libintl
	alsa? ( >=media-libs/alsa-lib-1.0.5 )
	pulseaudio? ( media-libs/libpulse[glib] )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	alsa? ( udev? ( virtual/libudev:= ) )
"

DEPEND="${COMMON_DEPEND}
"

src_configure() {
	mate_src_configure \
		--disable-null \
		$(use_enable alsa) \
		$(use_enable pulseaudio)
}
