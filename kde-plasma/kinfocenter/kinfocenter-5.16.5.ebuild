# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION=3.14.3
KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Utility providing information about the computer hardware"
HOMEPAGE="https://kde.org/applications/system/kinfocenter/"
SRC_URI+=" https://www.gentoo.org/assets/img/logo/gentoo-3d-small.png -> glogo-small.png"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="gles2 ieee1394 +opengl +pci wayland"

REQUIRED_USE="wayland? ( || ( gles2 opengl ) )"

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	x11-libs/libX11
	ieee1394? ( sys-libs/libraw1394 )
	opengl? (
		$(add_qt_dep qtgui 'gles2=')
		media-libs/mesa[gles2?,X(+)]
		!gles2? ( media-libs/glu )
	)
	pci? ( sys-apps/pciutils )
	wayland? (
		$(add_frameworks_dep kwayland)
		media-libs/mesa[egl]
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep plasma)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	$(add_qt_dep qtquickcontrols2)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package ieee1394 RAW1394)
		$(cmake-utils_use_find_package pci PCIUTILS)
		$(cmake-utils_use_find_package wayland EGL)
		$(cmake-utils_use_find_package wayland KF5Wayland)
	)

	if has_version "dev-qt/qtgui[gles2]"; then
		mycmakeargs+=( $(cmake-utils_use_find_package gles2 OpenGLES) )
	else
		mycmakeargs+=( $(cmake-utils_use_find_package opengl OpenGL) )
	fi

	kde5_src_configure
}

src_install() {
	kde5_src_install

	# TODO: Make this fully obsolete by /etc/os-release
	insinto /etc/xdg
	doins "${FILESDIR}"/kcm-about-distrorc

	insinto /usr/share/${PN}
	doins "${DISTDIR}"/glogo-small.png
}

pkg_postinst() {
	kde5_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		has_version "net-fs/nfs-utils" || \
			elog "Installing net-fs/nfs-utils will enable the NFS information module."

		has_version "net-fs/samba" || \
			elog "Installing net-fs/samba will enable the Samba status information module."
	fi
}
