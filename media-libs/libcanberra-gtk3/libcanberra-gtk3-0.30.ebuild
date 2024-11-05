# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="libcanberra"
MY_P="libcanberra-${PV}"
inherit libtool multilib-minimal

DESCRIPTION="GTK3 bindings for libcanberra, the portable sound event library"
HOMEPAGE="https://0pointer.de/lennart/projects/libcanberra/"
SRC_URI="https://0pointer.de/lennart/projects/${MY_PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="gnome"

COMMON_DEPEND="
	~media-libs/libcanberra-${PV}[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[X,${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/libcanberra-0.30-r8[gtk3(-)]
	gnome? (
		gnome-base/dconf
		gnome-base/gsettings-desktop-schemas )
"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

PATCHES=(
	# gtk: Don't assume all GdkDisplays are GdkX11Displays: broadway/wayland (from 'master')
	"${FILESDIR}/${MY_P}-wayland.patch"
)

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--disable-alsa
		--disable-oss
		--disable-pulse
		--disable-gstreamer
		--disable-gtk
		--enable-gtk3
		--disable-tdb
		--disable-udev
		--disable-lynx
		--disable-gtk-doc
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	# Disable parallel installation until bug #253862 is solved
	emake DESTDIR="${D}" -j1 install
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die

	rm "${ED}"/usr/include/canberra.h || die

	find "${ED}"/usr \( -iname libcanberra.pc -o -iname libcanberra.vapi \
		-o -iname libcanberra-multi.so -o -iname libcanberra-null.so \
		-o -iname libcanberra.so* \) -delete || die

	# This is needed for desktops different than GNOME, bug #520550
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/${MY_PN}-gtk-module.sh 40-${MY_PN}-gtk-module
}
