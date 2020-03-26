# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils systemd xdg

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="https://www.dropbox.com/"
SRC_URI="
	amd64? ( https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-${PV}.tar.gz )
	x86? ( https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86-${PV}.tar.gz )"

LICENSE="BSD-2 CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE="+librsync-bundled selinux X"

RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

BDEPEND="dev-util/patchelf"

# Be sure to have GLIBCXX_3.4.9, #393125
RDEPEND="
	X? (
		dev-libs/glib:2
		media-libs/fontconfig
		media-libs/freetype
		virtual/jpeg
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		x11-misc/wmctrl
		x11-themes/hicolor-icon-theme
	)
	!librsync-bundled? ( <net-libs/librsync-2 )
	selinux? ( sec-policy/selinux-dropbox )
	app-arch/bzip2
	dev-libs/libffi-compat:6
	dev-libs/popt
	net-misc/wget
	>=sys-devel/gcc-4.2.0
	sys-libs/zlib
	sys-libs/ncurses-compat:5"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	mv "${WORKDIR}"/.dropbox-dist/* "${S}" || die
	mv "${S}"/dropbox-lnx.*-${PV}/* "${S}" || die
	rmdir "${S}"/dropbox-lnx.*-${PV}/ || die
	rmdir .dropbox-dist || die
}

src_prepare() {
	default

	rm -vf libGL.so.1 libX11* libdrm.so.2 libffi.so.6 libpopt.so.0 wmctrl || die
	# tray icon doesnt load when removing libQt5* (bug 641416)
	#rm -vrf libQt5* libicu* qt.conf plugins/ || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -vrf PyQt5* *pyqt5* images || die
	fi
	if use librsync-bundled ; then
		patchelf --set-rpath '$ORIGIN' librsyncffi_native.*.so || die
	else
		rm -vf librsync.so.1 || die
	fi
	patchelf --set-rpath '$ORIGIN' \
		apex._apex.*.so \
		nucleus_python.*.so \
		tprt.*.so \
		|| die
	pax-mark cm dropbox
	mv README ACKNOWLEDGEMENTS "${T}" || die
}

src_install() {
	local targetdir="/opt/dropbox"

	insinto "${targetdir}"
	doins -r *
	fperms a+x "${targetdir}"/{dropbox,dropboxd}
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"

	use X && doicon -s 16 -c status "${T}"/status

	make_desktop_entry "${PN}" "Dropbox" "dropboxstatus-logo"

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service-r2 "dropbox@.service"

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}
