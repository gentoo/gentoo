# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# eutils inherit required for make_wrapper call
inherit desktop eutils multilib xdg-utils

DESCRIPTION="ICA Client for Citrix Presentation servers"
HOMEPAGE="https://www.citrix.com/"
SRC_URI="amd64? ( linuxx64-${PV}.tar.gz )
	x86? ( linuxx86-${PV}.tar.gz )"

LICENSE="icaclient"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="l10n_de l10n_es l10n_fr l10n_ja l10n_zh-CN"
RESTRICT="mirror strip userpriv fetch"

ICAROOT="/opt/Citrix/ICAClient"

QA_PREBUILT="${ICAROOT#/}/*"

RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl-compat:1.0.0
	media-fonts/font-adobe-100dpi
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	media-fonts/font-xfree86-type1
	media-fonts/font-misc-ethiopic
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/libogg
	media-libs/libvorbis
	media-libs/speex
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	net-misc/curl
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	virtual/krb5
	virtual/jpeg:0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
"
DEPEND=""

pkg_nofetch() {
	elog "Download the client file ${A} from
	https://www.citrix.com/downloads/workspace-app/"
	elog "and place it into your DISTDIR directory."
}

pkg_setup() {
	case ${ARCH} in
		amd64)
			ICAARCH=linuxx64
		;;
		x86)
			ICAARCH=linuxx86
		;;
		*)
			eerror "Given architecture is not supported by Citrix."
		;;
	esac

	S="${WORKDIR}/${ICAARCH}/${ICAARCH}.cor"
}

src_prepare() {
	default
	rm lib/UIDialogLibWebKit.so || die
}

src_install() {
	local bin tmpl dest

	dodir "${ICAROOT}"

	exeinto "${ICAROOT}"
	doexe *.DLL libAnalyticsInterfacePd.so libproxy.so wfica AuthManagerDaemon PrimaryAuthManager selfservice ServiceRecord

	exeinto "${ICAROOT}"/lib
	doexe lib/*.so

	for dest in "${ICAROOT}"{,/nls/en{,.UTF-8}} ; do
		insinto "${dest}"
		doins nls/en.UTF-8/eula.txt
	done

	insinto "${ICAROOT}"
	doins -r usb

	insinto "${ICAROOT}"/config
	doins config/* config/.* nls/en/*.ini
	for tmpl in {appsrv,wfclient}.template ; do
		newins nls/en/${tmpl} ${tmpl/template/ini}
	done
	touch "${ED}/${ICAROOT}"/config/.server || die

	insinto "${ICAROOT}"/gtk
	doins gtk/*

	insinto "${ICAROOT}"/gtk/glade
	doins gtk/glade/*

	insinto "${ICAROOT}"/site
	doins -r site/*

	dodir "${ICAROOT}"/help

	insinto "${ICAROOT}"/config/usertemplate
	doins config/usertemplate/*

	local lang LANGCODES=( en )
	use l10n_de && LANGCODES+=( de )
	use l10n_es && LANGCODES+=( es )
	use l10n_fr && LANGCODES+=( fr )
	use l10n_ja && LANGCODES+=( ja )
	use l10n_zh-CN && LANGCODES+=( zh_CN )

	for lang in ${LANGCODES[@]} ; do
		insinto "${ICAROOT}"/nls/${lang}
		doins nls/${lang}/*

		insinto "${ICAROOT}"/nls/$lang/UTF-8
		doins nls/${lang}.UTF-8/*

		insinto "${ICAROOT}"/nls/${lang}/LC_MESSAGES
		doins nls/${lang}/LC_MESSAGES/*

		insinto "${ICAROOT}"/nls/${lang}
		dosym UTF-8 "${ICAROOT}"/nls/${lang}/utf8

		for tmpl in {appsrv,wfclient}.template ; do
			cp "${ED}/${ICAROOT}"/nls/${lang}/${tmpl} \
				"${ED}/${ICAROOT}"/nls/${lang}/${tmpl/template/ini} \
				|| die
		done
	done

	insinto "${ICAROOT}"/nls
	dosym en /opt/Citrix/ICAClient/nls/C

	insinto "${ICAROOT}"/icons
	doins icons/*

	insinto "${ICAROOT}"/keyboard
	doins keyboard/*

	rm -r "${S}"/keystore/cacerts || die
	dosym /etc/ssl/certs "${ICAROOT}"/keystore/cacerts

	exeinto "${ICAROOT}"/util
	doexe util/{configmgr,conncenter,gst_play1.0,gst_read1.0,hdxcheck.sh,icalicense.sh,libgstflatstm1.0.so,webcontainer,ctxwebhelper,ctx_rehash,ctx_app_bind}
	doexe util/{lurdump,new_store,nslaunch,pnabrowse,storebrowse,sunraymac.sh,what,xcapture}

	# https://bugs.gentoo.org/655922
	dosym gst_play1.0 "${ICAROOT}"/util/gst_play
	dosym gst_read1.0 "${ICAROOT}"/util/gst_read
	dosym libgstflatstm1.0.so "${ICAROOT}"/util/libgstflatstm.so

	doenvd "${FILESDIR}"/10ICAClient

	for bin in configmgr conncenter new_store ; do
		make_wrapper ${bin} "${ICAROOT}"/util/${bin} . "${ICAROOT}"/util
	done

	for bin in selfservice wfica ; do
		make_wrapper ${bin} "${ICAROOT}"/${bin} . "${ICAROOT}"
	done

	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${ICAROOT}\"" \
		> "${ED}"/etc/revdep-rebuild/70icaclient

	# 651926
	domenu "${FILESDIR}"/*.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
