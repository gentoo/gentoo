# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils systemd xdg

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="https://www.dropbox.com/"
SRC_URI="
	https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-${PV}.tar.gz
	https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/dropbox-icon.svg
"

LICENSE="BSD-2 CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="selinux X"

RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

BDEPEND="dev-util/patchelf"

# Be sure to have GLIBCXX_3.4.9, #393125
RDEPEND="
	X? (
		x11-themes/hicolor-icon-theme
		dev-libs/libayatana-appindicator
	)
	selinux? ( sec-policy/selinux-dropbox )
	app-arch/bzip2
	dev-libs/glib:2
	dev-libs/libffi-compat:7
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
	rm -vf libGL.so.1 libX11* libffi.so.7 || die
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
		# symlinks for bug 955139
		dosym ../../usr/$(get_libdir)/libayatana-appindicator3.so.1 ${targetdir}/libappindicator3.so.1
		dosym libappindicator3.so.1 ${targetdir}/libappindicator3.so

		doicon -s 16 -c status "${T}"/status
		newicon -s scalable "${DISTDIR}/dropbox-icon.svg" dropbox.svg
	fi

	make_desktop_entry "${PN}" "Dropbox" "dropbox"

	newinitd "${FILESDIR}"/dropbox.initd dropbox
	newconfd "${FILESDIR}"/dropbox.conf dropbox
	systemd_newunit "${FILESDIR}"/dropbox_at.service-r2 "dropbox@.service"

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "Warning: while running, dropbox may attempt to autoupdate itself in"
	einfo " your user's home directory.  To prevent this, run the following as"
	einfo " each user who will run dropbox:"
	einfo ""
	einfo "install -dm0 ~/.dropbox-dist"
	einfo ""
	einfo "If you do allow dropbox to update/install to your user homedir, you"
	einfo " will need to create some compat symlinks to keep the tray icon working:"
	einfo ""
	einfo "ln -sf /usr/$(get_libdir)/libayatana-appindicator3.so.1 ~/.dropbox-dist/dropbox-lnx.*/libappindicator3.so.1"
	einfo "ln -sf libappindicator3.so.1 ~/.dropbox-dist/dropbox-lnx.*/libappindicator3.so"

	if has_version gnome-base/gnome-shell; then
		if ! has_version gnome-extra/gnome-shell-extension-appindicator; then
			einfo ""
			einfo "Please install gnome-extra/gnome-shell-extension-appindicator if you"
			einfo " require tray icon support for Dropbox in Gnome."
		fi
	fi

}
