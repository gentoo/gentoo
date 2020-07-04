# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Utility providing information about the computer hardware"
HOMEPAGE="https://userbase.kde.org/KInfoCenter"
SRC_URI+=" https://www.gentoo.org/assets/img/logo/gentoo-3d-small.png -> glogo-small.png"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="gles2-only ieee1394 +opengl +pci wayland"

REQUIRED_USE="wayland? ( || ( opengl gles2-only ) )"

BDEPEND=">=dev-util/cmake-3.14.3"
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[gles2-only=]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	x11-libs/libX11
	gles2-only? ( media-libs/mesa[gles2] )
	ieee1394? ( sys-libs/libraw1394 )
	opengl? (
		media-libs/mesa[X(+)]
		!gles2-only? ( media-libs/glu )
	)
	pci? ( sys-apps/pciutils )
	wayland? (
		>=kde-frameworks/kwayland-${KFMIN}:5
		media-libs/mesa[egl]
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/plasma-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ieee1394 RAW1394)
		$(cmake_use_find_package pci PCIUTILS)
		$(cmake_use_find_package wayland EGL)
		$(cmake_use_find_package wayland KF5Wayland)
	)

	if has_version "dev-qt/qtgui[gles2-only]"; then
		mycmakeargs+=( $(cmake_use_find_package gles2-only OpenGLES) )
	else
		mycmakeargs+=( $(cmake_use_find_package opengl OpenGL) )
	fi

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
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		has_version "net-fs/nfs-utils" || \
			elog "Installing net-fs/nfs-utils will enable the NFS information module."

		has_version "net-fs/samba" || \
			elog "Installing net-fs/samba will enable the Samba status information module."
	fi
}
