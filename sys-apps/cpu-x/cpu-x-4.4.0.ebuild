# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CPU-X"

inherit cmake gnome2-utils xdg

DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://thetumultuousunicornofdarkness.github.io/CPU-X/"
SRC_URI="https://github.com/TheTumultuousUnicornOfDarkness/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+cpu force-libstatgrab +gpu +gui +ncurses +nls opencl +pci test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gui? ( >=x11-libs/gtk+-3.12:3 )
	cpu? ( >=dev-libs/libcpuid-0.5.0:= )
	gpu? ( >=media-libs/glfw-3.3
		media-libs/libglvnd )
	pci? ( sys-apps/pciutils )
	ncurses? ( sys-libs/ncurses:=[tinfo] )
	opencl? ( virtual/opencl )
"

DEPEND="
	test? (
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

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_GTK=$(usex gui)
		-DWITH_LIBCPUID=$(usex cpu)
		-DWITH_LIBGLFW=$(usex gpu)
		-DWITH_LIBPCI=$(usex pci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_OPENCL=$(usex opencl)
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
