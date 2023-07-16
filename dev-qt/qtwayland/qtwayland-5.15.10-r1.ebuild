# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
fi

inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

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
BDEPEND="dev-util/wayland-scanner"

PATCHES=(
	# QTBUG-97037, pending upstream:
	# https://invent.kde.org/qt/qt/qtwayland/-/merge_requests/71
	"${FILESDIR}/${PN}-5.15.9-fix-mouse-stuck-in-pressed-state-after-DnD.patch"
	"${FILESDIR}/${P}-send-release-button-event-on-pointer-leave.patch"
	# bug #910315, pending upstream:
	# https://invent.kde.org/qt/qt/qtwayland/-/merge_requests/73
	"${FILESDIR}/${P}-Destroy-frame-queue-before-display.patch"
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
