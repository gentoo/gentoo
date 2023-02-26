# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 desktop pax-utils

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"
BIN_ARCHIVE="${MY_P}-linux_x64.bin"

DESCRIPTION="Complete set of tools that provide a virtual environment for Android"
HOMEPAGE="https://genymotion.com"
SRC_URI="${BIN_ARCHIVE}"

LICENSE="genymotion"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="app-arch/lz4
	app-crypt/mit-krb5
	|| (
		app-emulation/qemu[qemu_softmmu_targets_x86_64]
		app-emulation/virtualbox
	)
	|| (
		dev-libs/openssl-compat:1.1.0
		=dev-libs/openssl-1.1*:0
	)
	dev-libs/glib:2
	=dev-libs/hiredis-1.0*
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpulse
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	sys-apps/dbus
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libxkbcommon[X]
	x11-libs/libXmu
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
BDEPEND="x11-misc/xdg-utils"

RESTRICT="bindist fetch"
S="${WORKDIR}"

QA_PREBUILT="
	opt/${MY_PN}/*.so*
	opt/${MY_PN}/imageformats/*.so
	opt/${MY_PN}/plugins/*.so*
	opt/${MY_PN}/${MY_PN}
	opt/${MY_PN}/genyshell
	opt/${MY_PN}/player
	opt/${MY_PN}/${MY_PN}adbtunneld
	opt/${MY_PN}/gmtool
	opt/${MY_PN}/tools/*
"

pkg_nofetch() {
	einfo
	einfo "Please visit"
	einfo
	einfo "  https://www.genymotion.com/download/"
	einfo
	einfo "and download "
	einfo
	einfo "  ${BIN_ARCHIVE}"
	einfo
	einfo "which must be placed in DISTDIR directory."
	einfo
}

src_unpack() {
	cp "${DISTDIR}/${BIN_ARCHIVE}" "${WORKDIR}" || die "cp failed"
}

src_prepare() {
	default

	chmod +x ${BIN_ARCHIVE} || die "chmod failed"
	yes | ./${BIN_ARCHIVE} > /dev/null || die "unpack failed"

	# removed windows line for bashcompletion
	sed -i "/complete -F _gmtool gmtool.exe/d" "${MY_PN}/completion/bash/gmtool.bash" || die "sed failed"

	# copy .desktop file in S directory
	sed -i -e "s:Icon.*:Icon=/opt/${MY_PN}/icons/genymotion-logo.png:" \
		-e "s:Exec.*:Exec=/opt/${MY_PN}/genymotion:" \
		"${HOME}"/.local/share/applications/genymobile-genymotion.desktop || die "sed failed"
	cp "${HOME}"/.local/share/applications/genymobile-genymotion.desktop "${S}" || die "copy .desktop file"
}

src_install() {
	insinto /opt/"${MY_PN}"
	exeinto /opt/"${MY_PN}"

	# Use qt bundled
	doins -r "${MY_PN}"/{audio,geoservices,Qt,QtGraphicalEffects,QtLocation,QtPositioning,QtQuick,QtQuick.2}
	doins -r "${MY_PN}"/{icons,imageformats,mediaservice,platforms,plugins,sqldrivers,translations,xcbglintegrations}
	doins "${MY_PN}"/libQt*
	doins "${MY_PN}"/qt.conf
	doins "${MY_PN}"/libicu*

	doexe "${MY_PN}"/{libcom,librendering,libshadertranslator,libswscale,libavutil}.so*
	# android library
	doexe "${MY_PN}"/{libOpenglRender,libemugl_logger,libemugl_common}.so*

	find "${ED}/opt/${MY_PN}" -name "*.so*" -type f -exec chmod +x {} \; || die "Change .so permission failed"

	doexe "${MY_PN}"/{genymotion,genyshell,player,gmtool}

	# the android-sdk-update-manager have some bugs and lacks maintenance
	# so installs bundled version
	exeinto /opt/"${MY_PN}"/tools
	doexe "${MY_PN}"/tools/{aapt,adb,glewinfo}
	exeinto /opt/"${MY_PN}"/tools/lib64
	doexe "${MY_PN}"/tools/lib64/libc++.so

	pax-mark -m "${ED}/opt/${MY_PN}/genymotion"
	pax-mark -m "${ED}/opt/${MY_PN}/gmtool"

	dosym -r /opt/"${MY_PN}"/genyshell /opt/bin/genyshell
	dosym -r /opt/"${MY_PN}"/genymotion /opt/bin/genymotion
	dosym -r /opt/"${MY_PN}"/gmtool /opt/bin/gmtool

	newbashcomp "${MY_PN}/completion/bash/gmtool.bash" gmtool

	insinto /usr/share/zsh/site-functions
	doins "${MY_PN}/completion/zsh/_gmtool"

	if has_version app-emulation/qemu ; then
		dodir /opt/"${MY_PN}"/qemu/bin
		dosym  -r /usr/bin/qemu-system-x86_64 /opt/"${MY_PN}"/qemu/bin/qemu-system-x86_64
		dosym -r /usr/bin/qemu-img /opt/"${MY_PN}"/qemu/bin/qemu-img
	fi

	domenu genymobile-genymotion.desktop
}

pkg_postinst() {
	if has_version app-emulation/qemu && ! has_version app-emulation/virtualbox ; then
		ewarn "By default Genymotion is configured to work with VirtualBox hypervisor."
		ewarn "So you should run command:"
		ewarn ""
		ewarn "  gmtool config --hypervisor qemu"
		ewarn ""
		ewarn "to change hypervisor to QEMU."
	fi
}
