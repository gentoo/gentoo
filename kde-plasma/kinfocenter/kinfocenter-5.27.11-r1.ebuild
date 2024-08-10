# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org optfeature

DESCRIPTION="Utility providing information about the computer hardware"
HOMEPAGE="https://userbase.kde.org/KInfoCenter"
SRC_URI+=" https://www.gentoo.org/assets/img/logo/gentoo-3d-small.png -> glogo-small.png"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="gles2-only usb"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[gles2-only=]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	gles2-only? ( || (
		>=media-libs/mesa-24.1.0_rc1[opengl]
		<media-libs/mesa-24.1.0_rc1[gles2]
	) )
	usb? ( virtual/libusb:1 )
"
RDEPEND="${DEPEND}
	dev-qt/qdbus:*
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:*
	>=kde-plasma/systemsettings-${PVCUT}:5
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

CMAKE_SKIP_TESTS=(
	# bug 816591
	smbmountmodeltest
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package usb USB1)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# TODO: Make this fully obsolete by /etc/os-release
	insinto /etc/xdg
	doins "${FILESDIR}"/kcm-about-distrorc

	insinto /usr/share/${PN}
	doins "${DISTDIR}"/glogo-small.png
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature_header "Query network filesystem info:"
		optfeature "NFS information module" net-fs/nfs-utils
		optfeature "Samba status information module" net-fs/samba
		optfeature_header "Query firmware/hardware info:"
	fi
	optfeature "System DMI table readout" sys-apps/dmidecode
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Firmware security module" "app-text/aha sys-apps/fwupd"
		optfeature "PCI devices information module" sys-apps/pciutils
		optfeature "advanced CPU information module" sys-apps/util-linux
		optfeature_header "Query GPU/graphics support info:"
	fi
	optfeature "OpenCL information module" dev-util/clinfo
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "OpenGL information module" x11-apps/mesa-progs
		optfeature "Vulkan graphics API information module" dev-util/vulkan-tools
		optfeature "Wayland information module" app-misc/wayland-utils
		optfeature "X Server information module" x11-apps/xdpyinfo
	fi
	ecm_pkg_postinst
}
