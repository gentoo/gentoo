# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal systemd

DESCRIPTION="Portable sound event library"
HOMEPAGE="https://0pointer.de/lennart/projects/libcanberra/"
SRC_URI="https://0pointer.de/lennart/projects/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="alsa gstreamer oss pulseaudio tdb udev"

DEPEND="
	dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	alsa? (
		media-libs/alsa-lib:=[${MULTILIB_USEDEP}]
		udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] ) )
	gstreamer? ( media-libs/gstreamer:1.0[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	tdb? ( sys-libs/tdb:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	x11-themes/sound-theme-freedesktop" # Required for index.theme wrt #323379
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

REQUIRED_USE="udev? ( alsa )"

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable alsa)
		$(use_enable oss)
		$(use_enable pulseaudio pulse)
		$(use_enable gstreamer)
		--disable-gtk
		--disable-gtk3
		$(use_enable tdb)
		$(use_enable udev)
		--disable-lynx
		--disable-gtk-doc
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/gtkdoc/html gtkdoc/html || die
	fi
}

multilib_src_install() {
	# Disable parallel installation until bug #253862 is solved
	emake DESTDIR="${D}" -j1 install
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
