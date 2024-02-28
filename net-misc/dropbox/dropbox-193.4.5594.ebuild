# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils systemd xdg

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="https://www.dropbox.com/"
SRC_URI="
	amd64? ( https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-${PV}.tar.gz )
	x86? ( https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86-${PV}.tar.gz )
	https://www.dropbox.com/sh/42f8d4kq6yt5lte/AAD69lhaw6gy46W8HfQAm0GSa/Glyph/Dropbox/SVG/DropboxGlyph_Blue.svg
"

LICENSE="BSD-2 CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="selinux X"

RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

BDEPEND="dev-util/patchelf"

# Be sure to have GLIBCXX_3.4.9, #393125
RDEPEND="
	X? (
		x11-themes/hicolor-icon-theme
	)
	selinux? ( sec-policy/selinux-dropbox )
	app-arch/bzip2
	dev-libs/glib:2
	dev-libs/libffi-compat:6
	media-libs/fontconfig
	media-libs/freetype
	net-misc/wget
	sys-libs/zlib
	sys-libs/ncurses-compat:5
	virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb
"

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
	# we supply all of these in RDEPEND
	rm -vf libGL.so.1 libX11* libffi.so.6 || die
	# some of these do not appear to be used
	rm -vf libQt5{OpenGL,PrintSupport,Qml,Quick,Sql,WebKit,WebKitWidgets}.so.5 \
		PyQt5.QtPrintSupport.* PyQt5.QtQml.* PyQt5.QtQuick.*  \
		wmctrl libdrm.so.2 libpopt.so.0 || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -vrf images || die
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

	if use X; then
		doicon -s 16 -c status "${T}"/status
		newicon -s scalable "${DISTDIR}/DropboxGlyph_Blue.svg" dropbox.svg
	fi

	make_desktop_entry "${PN}" "Dropbox" "dropbox"

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service-r2 "dropbox@.service"

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}

pkg_postinst() {
	einfo "Warning: while running, dropbox may attempt to autoupdate itself in"
	einfo " your user's home directory.  To prevent this, run the following as"
	einfo " each user who will run dropbox:"
	einfo ""
	einfo "install -dm0 ~/.dropbox-dist"
}
