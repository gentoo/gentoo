# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=2
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"
SLOT=5/${QT5_PV} # bug 815646

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

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
	"${FILESDIR}/${PN}-5.15.2-QTBUG-90037-QTBUG-91264.patch" # upstream pending
	"${FILESDIR}/${PN}-5.15.3-clang.patch"
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

src_install() {
	qt5-build_src_install
	rm "${D}${QT5_BINDIR}"/qtwaylandscanner || die
}
