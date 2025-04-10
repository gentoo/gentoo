# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CPU-X"

inherit cmake gnome2-utils xdg

DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://thetumultuousunicornofdarkness.github.io/CPU-X/"
SRC_URI="https://github.com/TheTumultuousUnicornOfDarkness/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+cpu force-libstatgrab +gpu gui +ncurses +nls opencl +pci test vulkan"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gui? ( dev-cpp/gtkmm:3.0
		>=x11-libs/gtk+-3.12:3 )
	cpu? ( >=dev-libs/libcpuid-0.7.0:= )
	gpu? ( media-libs/libglvnd )
	pci? ( sys-apps/pciutils )
	ncurses? ( sys-libs/ncurses:=[tinfo] )
	opencl? ( virtual/opencl )
	vulkan? ( media-libs/vulkan-loader
		>=dev-util/vulkan-headers-1.3.151 )
"

DEPEND="
	test? (
		sys-apps/grep[pcre]
		sys-apps/mawk
		sys-apps/nawk
	)

	${COMMON_DEPEND}
"

BDEPEND="
	dev-lang/nasm
	nls? ( sys-devel/gettext )
"

RDEPEND="${COMMON_DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_GTK=$(usex gui)
		-DWITH_LIBCPUID=$(usex cpu)
		-DWITH_LIBEGL=$(usex gpu)
		-DWITH_LIBPCI=$(usex pci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_VULKAN=$(usex vulkan)
	)
	use gui && mycmakeargs+=( -DGSETTINGS_COMPILE=OFF )

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
