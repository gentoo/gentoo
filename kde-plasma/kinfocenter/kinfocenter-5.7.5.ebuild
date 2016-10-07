# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="A utility that provides information about a computer system"
HOMEPAGE="https://www.kde.org/applications/system/kinfocenter/"
SRC_URI+=" https://www.gentoo.org/assets/img/logo/gentoo-3d-small.png -> glogo-small.png"
KEYWORDS="amd64 ~arm x86"
IUSE="egl gles2 ieee1394 +opengl +pci wayland"

REQUIRED_USE="egl? ( || ( gles2 opengl ) )"

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kdelibs4support)
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
		media-libs/mesa[egl?,gles2?]
		!gles2? ( media-libs/glu )
	)
	pci? ( sys-apps/pciutils )
	wayland? ( $(add_frameworks_dep kwayland) )
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep plasma)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!kde-base/kcontrol:4
	!kde-base/kinfocenter:4
	!kde-misc/about-distro
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package egl EGL)
		$(cmake-utils_use_find_package gles2 OpenGLES)
		$(cmake-utils_use_find_package ieee1394 RAW1394)
		$(cmake-utils_use_find_package opengl OpenGL)
		$(cmake-utils_use_find_package pci PCIUTILS)
		$(cmake-utils_use_find_package wayland KF5Wayland)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	insinto /etc/xdg
	doins "${FILESDIR}"/kcm-about-distrorc

	insinto /usr/share/${PN}
	doins "${DISTDIR}"/glogo-small.png
}

pkg_postinst() {
	if ! has_version "net-fs/nfs-utils"; then
		einfo "Installing net-fs/nfs-utils will enable the NFS information module."
	fi
	if ! has_version "net-fs/samba" || ! has_version "net-fs/samba[server]"; then
		einfo "Installing net-fs/samba[server(+)] will enable the Samba status information module."
	fi
}
