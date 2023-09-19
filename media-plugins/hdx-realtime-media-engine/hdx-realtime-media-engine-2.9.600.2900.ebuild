# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV="$(ver_cut 1-3)"

DESCRIPTION="HDX RealTime Media Engine plugin for Citrix Workspace App"
HOMEPAGE="https://www.citrix.com/"
SRC_URI="amd64? ( HDX_RealTime_Media_Engine_${MY_PV}_for_Linux_x64.zip )
	x86? ( HDX_RealTime_Media_Engine_${MY_PV}_for_Linux.zip )"
LICENSE="icaclient"
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch mirror strip"

BDEPEND="app-arch/unzip"
RDEPEND="
	sys-libs/llvm-libunwind
	|| (
		media-video/pipewire
		media-sound/pulseaudio
		media-sound/apulse
	)
	!<net-misc/icaclient-22.12.0.12
	x11-libs/libX11
	x11-libs/libXv
"

ICAROOT="/opt/Citrix/ICAClient"
QA_PREBUILT="${ICAROOT#/}/*"

REQUIRES_EXCLUDE="
	libpulse.so.0
	libsndfile.so.1
"

S="${WORKDIR}/usr/local/bin"

pkg_nofetch() {
	elog "Download the client file ${A} from"
	elog "https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine.html"
	elog "and place it into your DISTDIR directory."
}

pkg_setup() {
	case ${ARCH} in
		amd64)
			zip_dir="x86_64"
			zip_arch="amd64"
		;;
		x86)
			zip_dir="i386"
			zip_arch="i386"
		;;
	esac
}

src_unpack() {
	default

	local MY_T="${WORKDIR}/HDX_RealTime_Media_Engine_${MY_PV}_for_Linux$(usex amd64 '_x64' '')"
	local deb_base_name="citrix-hdx-realtime-media-engine"
	unpack_deb ${MY_T}/${zip_dir}/${deb_base_name}_$(ver_rs 3 -)_${zip_arch}.deb
}

src_install() {
	insinto "${ICAROOT}/rtme"

	# No, we do NOT install such a generic udev rule into the system
	local destfiles=(
		DialTone_US.wav
		EULA.rtf
		InboundCallRing.wav
	)

	local el
	for el in "${destfiles[@]}" ; do
		doins "${el}"
	done

	exeinto "${ICAROOT}"/rtme
	doexe RTMEconfig RTMediaEngineSRV

	for el in /var/{lib,log}/RTMediaEngineSRV /var/lib/Citrix/HDXRMEP ; do
		keepdir ${el}
		fperms a+rw ${el}
	done

	insinto "${ICAROOT}"
	doins HDXRTME.so
}
