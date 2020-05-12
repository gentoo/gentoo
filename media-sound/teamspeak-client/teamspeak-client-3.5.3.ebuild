# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs unpacker xdg-utils

MY_PV="${PV/_/-}"

DESCRIPTION="A client software for quality voice communication via the internet"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="
	amd64? ( https://files.teamspeak-services.com/releases/client/${PV}/TeamSpeak3-Client-linux_amd64-${MY_PV}.run )
	x86? ( https://files.teamspeak-services.com/releases/client/${PV}/TeamSpeak3-Client-linux_x86-${MY_PV}.run )
"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="teamspeak3 || ( GPL-2 GPL-3 LGPL-3 )"
SLOT="0"
IUSE="+alsa pulseaudio"
REQUIRED_USE="|| ( alsa pulseaudio )"

BDEPEND="dev-util/patchelf"

RDEPEND="
	app-arch/snappy:0/1
	dev-libs/openssl:0
	dev-libs/quazip
	dev-qt/qtcore:5
	|| (
		dev-qt/qtgui:5[accessibility,dbus,X(-)]
		dev-qt/qtgui:5[accessibility,dbus,xcb(-)]
	)
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5[geolocation(+),widgets]
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	net-libs/libsrtp:0
	sys-libs/libcxx[libcxxabi]
	sys-libs/zlib:0/1
	virtual/udev
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"

RESTRICT="bindist mirror"

S="${WORKDIR}"

QA_PREBUILT="
	opt/teamspeak3-client/error_report
	opt/teamspeak3-client/package_inst
	opt/teamspeak3-client/soundbackends/libalsa_linux_*.so
	opt/teamspeak3-client/soundbackends/libpulseaudio_linux_*.so
	opt/teamspeak3-client/ts3client
	opt/teamspeak3-client/update
"

src_prepare() {
	default

	if ! use alsa; then
		rm -f soundbackends/libalsa_linux_*.so || die
	fi

	if ! use pulseaudio ; then
		rm -f soundbackends/libpulseaudio_linux_*.so || die
	fi

	mv ts3client_linux_* ts3client || die

	# Fixes QA Notice: Unresolved soname dependencies.
	# Since this is a binary only package, it must be patched.
	local soname_files=( "error_report" "ts3client" )
	for soname_file in ${soname_files[@]}; do
		patchelf --replace-needed libquazip.so libquazip5.so.1 "${soname_file}" || die
	done

	tc-export CXX
}

src_install() {
	exeinto /opt/teamspeak3-client
	doexe error_report package_inst ts3client update
	newexe "${FILESDIR}"/ts3client-bin-r2 ts3client-bin

	exeinto /opt/teamspeak3-client/soundbackends
	doexe soundbackends/*.so

	insinto /opt/teamspeak3-client
	doins -r gfx html resources sound styles translations

	dosym ../../usr/$(get_libdir)/qt5/libexec/QtWebEngineProcess /opt/teamspeak3-client/QtWebEngineProcess

	dodir /opt/bin
	dosym ../teamspeak3-client/ts3client-bin /opt/bin/ts3client

	make_desktop_entry /opt/bin/ts3client "Teamspeak 3 Client" /opt/teamspeak3-client/styles/default/logo-128x128.png "Audio;AudioVideo;Network"

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
