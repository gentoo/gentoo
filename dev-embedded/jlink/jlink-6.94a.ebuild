# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils udev

INSTALLDIR="/opt/${PN}"

DESCRIPTION="Tools for Segger J-Link JTAG adapters"
HOMEPAGE="https://www.segger.com/jlink-software.html"
SRC_URI="https://www.segger.com/downloads/jlink/JLink_Linux_V${PV/./}_x86_64.tgz"
LICENSE="SEGGER"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""
QA_PREBUILT="*"

RESTRICT="fetch strip"
RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	sys-devel/gcc
	sys-libs/glibc
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
"

S="${WORKDIR}/JLink_Linux_V${PV/./}_x86_64"

pkg_nofetch() {
	einfo "Segger requires you to accept their license agreement before downloading."
	einfo "Download ${SRC_URI}"
	einfo "with your browser and place it in DISTDIR (usually /var/cache/distfiles/)"
}

src_install() {
	local bins=(
		JFlashExe
		JFlashLiteExe
		JFlashSPI_CL
		JFlashSPIExe
		JLinkConfigExe
		JLinkExe
		JLinkGDBServerCLExe
		JLinkGDBServer
		JLinkGUIServerExe
		JLinkLicenseManager
		JLinkRegistration
		JLinkRemoteServerCLExe
		JLinkRemoteServer
		JLinkRTTClient
		JLinkRTTLogger
		JLinkRTTViewerExe
		JLinkSTM32
		JLinkSWOViewerCLExe
		JLinkSWOViewer
		JMemExe
		JRunExe
		JTAGLoadExe
	)
	local wrapper
	for wrapper in "${bins[@]}"; do
		make_wrapper "${wrapper}" ./"${wrapper}" "${INSTALLDIR}"
	done

	exeinto "${INSTALLDIR}"
	doexe "${bins[@]}"

	insinto "${INSTALLDIR}"
	local libs=(
		libjlinkarm.so*
		libQtCore.so*
		libQtGui.so*
	)

	local lib
	for lib in "${libs[@]}"; do
		# Use doins for symlinks to avoid making unnecessary copies of the libs.
		if [[ -L "${lib}" ]]; then
			doins "${lib}"
		else
			doexe "${lib}"
		fi
	done

	doins -r \
		README.txt \
		Doc \
		Samples \
		Devices \
		ETC \
		GDBServer

	udev_dorules 99-jlink.rules
}
