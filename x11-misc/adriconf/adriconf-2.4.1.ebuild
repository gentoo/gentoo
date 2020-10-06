# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Advanced DRI Configurator"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/adriconf/"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/adriconf.git"
else
	MY_P="${PN}-v${PV}"
	SRC_URI="https://gitlab.freedesktop.org/mesa/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi
LICENSE="GPL-3"
SLOT="0"

IUSE="wayland"

RDEPEND="
	dev-cpp/atkmm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/libxmlpp:3.0
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libsigc++:2
	media-libs/libglvnd
	media-libs/mesa[egl(+)]
	sys-apps/pciutils
	x11-libs/libdrm
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
	sed '/^Version/d' -i flatpak/org.freedesktop.${PN}.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS="false"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	local org="flatpak/org.freedesktop.${PN}"

	insinto /usr/share/metainfo
	doins ${org}.metainfo.xml
	domenu ${org}.desktop
	doicon ${org}.png
}
