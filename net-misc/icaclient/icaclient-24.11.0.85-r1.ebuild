# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg-utils

DESCRIPTION="ICA Client for Citrix Presentation servers"
HOMEPAGE="https://www.citrix.com/"
SRC_URI="amd64? ( linuxx64-${PV}.tar.gz )"

LICENSE="icaclient"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="l10n_de l10n_es l10n_fr l10n_ja l10n_zh-CN hdx usb selfservice"
RESTRICT="mirror strip fetch"

ICAROOT="/opt/Citrix/ICAClient"

QA_PREBUILT="${ICAROOT#/}/*"

# we have binaries for two conflicting kerberos implementations
# https://bugs.gentoo.org/792090
# https://bugs.gentoo.org/775995
REQUIRES_EXCLUDE="
	libgssapi.so.3
	libgssapi_krb5.so.2 libkrb5.so.3
"
# when using media-plugins/hdx-realtime-media-engine we better not ignore that
REQUIRES_EXCLUDE="${REQUIRES_EXCLUDE}
	!hdx? ( libunwind.so.1 )
"
# we have binaries which wouls still support gstreamer:0.10
REQUIRES_EXCLUDE="${REQUIRES_EXCLUDE}
	libgstapp-0.10.so.0
	libgstbase-0.10.so.0
	libgstinterfaces-0.10.so.0
	libgstpbutils-0.10.so.0
	libgstreamer-0.10.so.0
"

# video background blurring, optional
REQUIRES_EXCLUDE="${REQUIRES_EXCLUDE}
	libopencv_core.so.407
	libopencv_imgcodecs.so.407
	libopencv_imgproc.so.407
"

BDEPEND="
	hdx? ( media-plugins/hdx-realtime-media-engine )
"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/glib:2
	|| (
		dev-libs/libxml2:2/0
		dev-libs/libxml2-compat
	)
	media-fonts/font-adobe-100dpi
	media-fonts/font-cursor-misc
	media-fonts/font-misc-ethiopic
	media-fonts/font-misc-misc
	media-fonts/font-xfree86-type1
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/libogg
	media-libs/libpng
	media-libs/libpulse
	media-libs/libva
	media-libs/libvorbis
	media-libs/mesa
	media-libs/speex
	media-libs/speexdsp
	net-libs/libsoup:2.4
	sys-apps/util-linux
	llvm-runtimes/libcxx
	llvm-runtimes/libcxxabi
	sys-libs/zlib
	virtual/krb5
	virtual/libudev
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
	${BDEPEND}
	!hdx? ( !media-plugins/hdx-realtime-media-engine )
	usb? ( virtual/libudev )
	selfservice? (
		net-libs/webkit-gtk:4.1
		dev-libs/xerces-c
	)
"

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
}

src_unpack() {
	default
	mv "${WORKDIR}/${ICAARCH}/${ICAARCH}.cor" "${S}" || die
}

src_prepare() {
	default
	rm lib/UIDialogLibWebKit.so || die

	cp nls/en/module.ini . || die
	if use usb; then
		# inspired by debian usb support package postinst
		sed -i -e 's/^[ \t]*VirtualDriver[ \t]*=.*$/&, GenericUSB/' module.ini || die
		sed -i -e '/\[ICA 3.0\]/a\GenericUSB=on' module.ini || die
		echo "[GenericUSB]" >> module.ini
		echo "DriverName=VDGUSB.DLL" >> module.ini
	fi

	if use hdx; then
		"${BROOT}${ICAROOT}"/rtme/RTMEconfig -install -ignoremm || die
		mv new_module.ini module.ini || die
	fi
	mv module.ini config/ || die
}

src_install() {
	local bin tmpl dest

	dodir "${ICAROOT}"

	keepdir /etc/icaclient

	insinto "${ICAROOT}"
	exeinto "${ICAROOT}"
	doexe *.DLL libproxy.so wfica AuthManagerDaemon PrimaryAuthManager selfservice ServiceRecord
	if use usb; then
		doexe usb/ctxusb usb/ctxusbd usb/ctx_usb_isactive
		doins usb/*.DLL
		insinto /etc/icaclient
		doins usb/usb.conf
		dosym ../../../etc/icaclient/usb.conf "${ICAROOT}"/usb.conf
		insinto "${ICAROOT}"
	fi

	exeinto "${ICAROOT}"/lib
	doexe lib/*.so

	for dest in "${ICAROOT}"{,/nls/en{,.UTF-8}} ; do
		insinto "${dest}"
		doins nls/en.UTF-8/eula.txt
	done

	insinto "${ICAROOT}"/config
	doins config/*
	mv "${ED}/${ICAROOT}"/config/module.ini "${ED}"/etc/icaclient/ || die
	dosym ../../../../etc/icaclient/module.ini "${ICAROOT}"/config/module.ini
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

	cp -a util "${ED}/${ICAROOT}" || die
	test -f util/HdxRtcEngine && fperms 0755 "${ICAROOT}"/util/HdxRtcEngine

	dosym ../../../../etc/ssl/certs "${ICAROOT}"/keystore/cacerts
	insinto "${ICAROOT}"/keystore/intcerts
	doins keystore/intcerts/*

	local other_files=(
		icasessionmgr
		NativeMessagingHost
		UtilDaemon
	)

	exeinto "${ICAROOT}"
	for bin in ${other_files[@]} ; do
		doexe ${bin}
	done

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

	insinto "${ICAROOT}"/pkginf
	newins "${WORKDIR}"/PkgId Ver.core."${ICAARCH}"

	# 651926
	domenu "${FILESDIR}"/*.desktop

	insinto /usr/share/mime/packages
	doins desktop/Citrix-mime_types.xml
}

pkg_preinst() {
	# previous versions of the ebuild created that and left it around
	# we own it now and avoid conflict warnings with this
	rm -f "${ROOT}${ICAROOT}/config/module.ini" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	if ! use hdx; then
		if [ -x "${ROOT}${ICAROOT}"/rtme/RTMEconfig ]; then
			ewarn "Starting from 22.12.0.12 you have to set USE=hdx if you want"
			ewarn "to use media-plugins/hdx-realtime-media-engine. Which does"
			ewarn "not need to be explicitly installed anymore."
		fi
	fi

	if use usb; then
		einfo
		einfo "Add users of ${CATEGORY}/${PN} to group 'usb' for redirect to work"
		einfo
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
