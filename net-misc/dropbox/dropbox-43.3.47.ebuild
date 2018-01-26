# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit eutils gnome2-utils pax-utils systemd python-single-r1

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="
	x86? ( https://dl.dropboxusercontent.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( https://dl.dropboxusercontent.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="+librsync-bundled selinux X"
RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="librsync-bundled? ( dev-util/patchelf )"

# Be sure to have GLIBCXX_3.4.9, #393125
# USE=X require wxGTK's dependencies. system-library cannot be used due to
# missing symbol (CtlColorEvent). #443686
RDEPEND="${PYTHON_DEPS}
	X? (
		dev-libs/glib:2
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5[-gles2,xcb]
		dev-qt/qtopengl:5[-gles2]
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5[-gles2]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5[-gles2]
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
	dev-libs/popt
	net-misc/wget
	>=sys-devel/gcc-4.2.0
	sys-libs/zlib
	|| (
		sys-libs/ncurses:5/5
		sys-libs/ncurses:0/5
	)"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	mv "${WORKDIR}"/.dropbox-dist/* "${S}" || die
	mv "${S}"/dropbox-lnx.*-${PV}/* "${S}" || die
	rmdir "${S}"/dropbox-lnx.*-${PV}/ || die
	rmdir .dropbox-dist || die
}

src_prepare() {
	eapply_user

	rm -vf libGL.so.1 libX11* libdrm.so.2 libffi.so.6 libpopt.so.0 wmctrl || die
	# tray icon doesnt load when removing libQt5* (bug 641416)
	#rm -vrf libQt5* libicu* qt.conf plugins/ || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -vrf PyQt5* *pyqt5* images || die
	fi
	if use librsync-bundled ; then
		patchelf --set-rpath '$ORIGIN' librsyncffi.compiled._librsyncffi*.so || die
	else
		rm -vf librsync.so.1 || die
	fi
	pax-mark cm dropbox
	mv README ACKNOWLEDGEMENTS "${T}" || die
}

src_install() {
	local targetdir="/opt/dropbox"

	insinto "${targetdir}"
	doins -r *
	fperms a+x "${targetdir}"/{dropbox,dropbox_py3,dropboxd}
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"

	use X && doicon -s 16 -c status "${T}"/status

	make_desktop_entry "${PN}" "Dropbox"

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service-r1 "dropbox@.service"

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
