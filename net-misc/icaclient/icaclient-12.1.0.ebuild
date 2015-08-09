# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib eutils rpm

DESCRIPTION="ICA Client for Citrix Presentation servers"
HOMEPAGE="http://www.citrix.com/"
# NB: the amd64 package contains 32bit code only
SRC_URI="x86? ( ICAClient-12.1.0-0.i386.rpm )
	amd64? ( ICAClient_12.1.0-0.x86_64.rpm )"

LICENSE="icaclient"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="nsplugin linguas_de linguas_ja"
RESTRICT="mirror strip userpriv fetch"

ICAROOT="/opt/Citrix/ICAClient"

QA_TEXTRELS="opt/Citrix/ICAClient/VDSCARD.DLL
	opt/Citrix/ICAClient/TW1.DLL
	opt/Citrix/ICAClient/NDS.DLL
	opt/Citrix/ICAClient/CHARICONV.DLL
	opt/Citrix/ICAClient/PDCRYPT1.DLL
	opt/Citrix/ICAClient/VDCM.DLL
	opt/Citrix/ICAClient/libctxssl.so
	opt/Citrix/ICAClient/PDCRYPT2.DLL
	opt/Citrix/ICAClient/npica.so
	opt/Citrix/ICAClient/VDSPMIKE.DLL
	opt/Citrix/ICAClient/VDFLASH2.DLL
	opt/Citrix/ICAClient/lib/libavutil.so
	opt/Citrix/ICAClient/lib/libavcodec.so
	opt/Citrix/ICAClient/lib/libavformat.so
	opt/Citrix/ICAClient/lib/libswscale.so"

QA_EXECSTACK="opt/Citrix/ICAClient/wfica
	opt/Citrix/ICAClient/libctxssl.so"

RDEPEND="
	x11-terms/xterm
	media-fonts/font-adobe-100dpi
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	media-fonts/font-xfree86-type1
	media-fonts/font-misc-ethiopic
	amd64? ( nsplugin? ( www-plugins/nspluginwrapper ) )
	>=app-crypt/mit-krb5-1.12.1-r2[abi_x86_32(-)]
	>=dev-libs/atk-2.10.0[abi_x86_32(-)]
	>=dev-libs/glib-2.38.2-r1:2[abi_x86_32(-)]
	>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
	>=media-libs/gst-plugins-base-0.10.36:0.10[abi_x86_32(-)]
	>=media-libs/gstreamer-0.10.36-r2:0.10[abi_x86_32(-)]
	>=media-libs/libogg-1.3.0[abi_x86_32(-)]
	>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	>=media-libs/speex-1.2_rc1-r1[abi_x86_32(-)]
	>=virtual/ffmpeg-9-r1[abi_x86_32(-)]
	>=x11-libs/cairo-1.12.14-r4[abi_x86_32(-)]
	>=x11-libs/gdk-pixbuf-2.30.7:2[abi_x86_32(-)]
	>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
	>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
	>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXaw-1.0.11-r2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXinerama-1.1.3[abi_x86_32(-)]
	>=x11-libs/libXmu-1.1.1-r1[abi_x86_32(-)]
	>=x11-libs/libXp-1.0.2[abi_x86_32(-)]
	>=x11-libs/libXpm-3.5.10-r1[abi_x86_32(-)]
	>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
	>=x11-libs/libXt-1.1.4[abi_x86_32(-)]
	>=x11-libs/motif-2.3.4-r1:0[abi_x86_32(-)]
	>=x11-libs/pango-1.36.3[abi_x86_32(-)]
	media-libs/flac[abi_x86_32(-)]
"

DEPEND=""
S="${WORKDIR}${ICAROOT}"

pkg_nofetch() {
	elog "Download the client RPM file ${SRC_URI} from
	http://www.citrix.com/English/ss/downloads/details.asp?downloadId=2323812&productId=1689163"
	elog "and place it in ${DISTDIR:-/usr/portage/distfiles}."
}

pkg_setup() {
		# Binary x86 package
		has_multilib_profile && ABI="x86"
}

src_install() {
	dodir "${ICAROOT}"

	exeinto "${ICAROOT}"
	doexe *.DLL libctxssl.so libproxy.so FlashContainer.bin wfica wfcmgr.bin util/wfcmgr

	exeinto "${ICAROOT}"/lib
	doexe lib/*.so

	insinto "${ICAROOT}"
	if use nsplugin
	then
		doins npica.so
		dosym "${ICAROOT}"/npica.so /usr/$(get_libdir)/nsbrowser/plugins/npica.so
	fi

	doins nls/en/eula.txt

	insinto "${ICAROOT}"/config
	doins config/* config/.* nls/en/*.ini

	insinto "${ICAROOT}"/gtk
	doins gtk/*

	insinto "${ICAROOT}"/gtk/glade
	doins gtk/glade/*

	dodir "${ICAROOT}"/help

	insinto "${ICAROOT}"/config/usertemplate
	doins config/usertemplate/*

	LANGCODES="en"
	use linguas_de && LANGCODES="${LANGCODES} de"
	use linguas_ja && LANGCODES="${LANGCODES} ja"

	for lang in ${LANGCODES}; do
		insinto "${ICAROOT}"/nls/${lang}
		doins nls/${lang}/*

		insinto "${ICAROOT}"/nls/$lang/UTF-8
		doins nls/${lang}/UTF-8/*

		insinto "${ICAROOT}"/nls/${lang}/LC_MESSAGES
		doins nls/${lang}/LC_MESSAGES/*

		insinto "${ICAROOT}"/nls/${lang}
		dosym UTF-8 "${ICAROOT}"/nls/${lang}/utf8

		# We don't have 'more' anymore on the system - use 'less' instead
		sed -e 's:MORE_CMD=more:MORE_CMD=less:g' -i "${D}"/"${ICAROOT}"/nls/${lang}/wfcmgr.msg
	done

	insinto "${ICAROOT}"/nls
	dosym en /opt/Citrix/ICAClient/nls/C

	insinto "${ICAROOT}"/icons
	doins icons/*

	insinto "${ICAROOT}"/keyboard
	doins keyboard/*

	rm -rf "${S}"/keystore/cacerts
	dosym /etc/ssl/certs "${ICAROOT}"/keystore/cacerts
	#insinto "${ICAROOT}"/keystore/cacerts
	#doins keystore/cacerts/*

	insinto "${ICAROOT}"/util
	doins util/pac.js

	exeinto "${ICAROOT}"/util
	doexe util/{DeleteCompleteFlashCache.sh,echo_cmd,hdxcheck.sh,icalicense.sh,integrate.sh}
	doexe util/{nslaunch,pacexec,pnabrowse,sunraymac.sh,what,xcapture}

	# Citrix receiver 12 has util/gst_{play,read}.{32,64} versions, install both
	doexe util/gst_{play,read}.{32,64}
	# Ditto for libgstflatstm.so
	doexe util/libgstflatstm.{32,64}.so

	dosym "${ICAROOT}"/util/integrate.sh "${ICAROOT}"/util/disintegrate.sh

	doenvd "${FILESDIR}"/10ICAClient

	make_wrapper wfica "${ICAROOT}"/wfica . "${ICAROOT}"

	# The .desktop file included in the rpm links to /usr/lib, so we
	# make a new one.  The program gives errors and has slowdowns if
	# the locale is not English, so strip it since it has no
	# translations anyway
	doicon icons/*
	make_wrapper wfcmgr "${ICAROOT}"/wfcmgr . "${ICAROOT}"
	sed -e  's:^\# Configuration items.*:. "${ICAROOT}"/nls/en/wfcmgr.msg:g' -i "${D}"/"${ICAROOT}"/wfcmgr
	make_desktop_entry wfcmgr 'Citrix ICA Client' manager

	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK="${ICAROOT}"" > "${D}"/etc/revdep-rebuild/70icaclient
}
