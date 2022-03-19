# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=d6a6b727832819d118199f7016c2c401663ee370
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

SLOT=5/${QT5_PV} # bug 815646
IUSE="vulkan X"

DEPEND="
	dev-libs/wayland
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtdeclarative-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=[egl,libinput,vulkan=,X?]
	media-libs/libglvnd
	vulkan? ( dev-util/vulkan-headers )
	X? (
		=dev-qt/qtgui-${QT5_PV}*[-gles2-only]
		x11-libs/libX11
		x11-libs/libXcomposite
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}/${P}-QTBUG-90037-QTBUG-91264.patch"
	"${FILESDIR}/${P}-fix-qmake-deps.patch"
	"${FILESDIR}/${P}-guard-mResizeDirty.patch"
	"${FILESDIR}/${P}-fixup-mutexes.patch"
)

src_configure() {
	local myqmakeargs=(
		--
		$(qt_use vulkan feature-wayland-vulkan-server-buffer)
		$(qt_use X feature-xcomposite-egl)
		$(qt_use X feature-xcomposite-glx)
	)
	qt5-build_src_configure
}
