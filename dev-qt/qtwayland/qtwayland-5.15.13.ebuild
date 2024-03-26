# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

SLOT=5/${QT5_PV} # bug 815646
IUSE="compositor vulkan"

RDEPEND="
	dev-libs/wayland
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=[egl,libinput,vulkan=]
	media-libs/libglvnd
	x11-libs/libxkbcommon
	compositor? ( =dev-qt/qtdeclarative-${QT5_PV}*:5= )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="dev-util/wayland-scanner"

src_configure() {
	local myqmakeargs=(
		--
		-no-feature-xcomposite-egl
		-no-feature-xcomposite-glx
		$(qt_use compositor feature-wayland-server)
		$(qt_use compositor feature-wayland-dmabuf-server-buffer)
		$(qt_use compositor feature-wayland-drm-egl-server-buffer)
		$(qt_use compositor feature-wayland-shm-emulation-server-buffer)
	)

	use compositor && myqmakeargs+=(
		$(qt_use vulkan feature-wayland-vulkan-server-buffer)
	)

	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install
	rm "${D}${QT5_BINDIR}"/qtwaylandscanner || die
}
