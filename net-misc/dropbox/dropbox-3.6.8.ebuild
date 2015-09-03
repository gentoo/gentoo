# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils pax-utils systemd

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="
	x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="+librsync-bundled selinux X"
RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

DEPEND="librsync-bundled? ( dev-util/patchelf )"

# Be sure to have GLIBCXX_3.4.9, #393125
# USE=X require wxGTK's dependencies. system-library cannot be used due to
# missing symbol (CtlColorEvent). #443686
RDEPEND="
	X? (
		dev-libs/glib:2
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtquick1:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		media-libs/libpng:1.2
		sys-libs/zlib
		virtual/jpeg
		x11-libs/gtk+:2
		x11-libs/libSM
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		x11-misc/wmctrl
		x11-themes/hicolor-icon-theme
	)
	!librsync-bundled? ( net-libs/librsync )
	selinux? ( sec-policy/selinux-dropbox )
	app-arch/bzip2
	dev-lang/python:2.7
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
	mkdir -p "${S}"
	mv "${WORKDIR}"/.dropbox-dist/* "${S}" || die
	mv "${S}"/dropbox-lnx.*-${PV}/* "${S}" || die
	rmdir .dropbox-dist
}

src_prepare() {
	local target=(
		cffi-0.8.6-py2.7-*.egg
		dropbox_sqlite_ext-0.0-py2.7.egg
		futures-2.1.3-py2.7.egg
		requests-1.2.3-py2.7.egg
		setuptools-12.3-py2.7.egg
	)

	rm -vf libbz2* libpopt.so.0 libpng12.so.0 || die
	rm -vf libdrm.so.2 libffi.so.6 libGL.so.1 libX11* || die
	rm -vf libQt5* libicu* qt.conf || die
	rm -vf wmctrl || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -vrf PyQt5* *pyqt5* images || die
	fi
	if use librsync-bundled ; then
		patchelf --set-rpath '$ORIGIN' _librsync.so || die
	else
		rm -vf librsync.so.1 || die
	fi
	mv ${target[@]} "${T}" || die
	rm -rf *.egg library.zip || die
	(cd "${T}"; mv ${target[@]} "${S}") || die
	ln -s dropbox library.zip || die
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

	make_desktop_entry "${PN}" "Dropbox"

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service "dropbox@.service"

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
