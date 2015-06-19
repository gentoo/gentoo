# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/chrome-remote-desktop/chrome-remote-desktop-40.0.2214.44.ebuild,v 1.1 2015/01/06 20:15:37 vapier Exp $

# Base URL: https://dl.google.com/linux/chrome-remote-desktop/deb/
# Fetch the Release file:
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/Release
# Which gives you the Packages file:
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-i386/Packages
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-amd64/Packages
# And finally gives you the file name:
#  pool/main/c/chrome-remote-desktop/chrome-remote-desktop_29.0.1547.32_amd64.deb
#
# Use curl to find the answer:
#  curl -q https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-i386/Packages | grep ^Filename

EAPI="4"

inherit unpacker

DESCRIPTION="access remote computers via Chrome!"
PLUGIN_URL="https://chrome.google.com/remotedesktop"
HOMEPAGE="https://support.google.com/chrome/answer/1649523 ${PLUGIN_URL}"
BASE_URI="https://dl.google.com/linux/chrome-remote-desktop/deb/pool/main/c/${PN}/${PN}_${PV}"
SRC_URI="amd64? ( ${BASE_URI}_amd64.deb )
	x86? ( ${BASE_URI}_i386.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

# All the libs this package links against.
RDEPEND="app-admin/sudo
	dev-lang/python
	>=dev-libs/expat-2
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-python/psutil
	gnome-base/gconf:2
	media-libs/fontconfig
	media-libs/freetype:2
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/pam
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/pango"
# Settings we just need at runtime.
RDEPEND+="
	x11-base/xorg-server[xvfb]"
DEPEND=""

S=${WORKDIR}

QA_PREBUILT="/opt/google/chrome-remote-desktop/*"

src_install() {
	insinto /etc
	doins -r etc/opt

	insinto /opt
	doins -r opt/google
	chmod a+rx "${ED}"/opt/google/${PN}/* || die

	dodir /etc/pam.d
	dosym system-remote-login /etc/pam.d/${PN}

	dodoc usr/share/doc/${PN}/changelog*

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Two ways to launch the server:"
		elog "(1) access an existing desktop"
		elog "    (a) install the Chrome plugin on the server & client:"
		elog "        ${PLUGIN_URL}"
		elog "    (b) on the server, run the Chrome plugin & enable remote access"
		elog "    (c) on the client, connect to the server"
		elog "(2) headless system"
		elog "    (a) install the Chrome plugin on the client:"
		elog "        ${PLUGIN_URL}"
		elog "    (b) visit https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/chromoting+https://www.googleapis.com/auth/googletalk+https://www.googleapis.com/auth/userinfo.email&access_type=offline&redirect_uri=https://chromoting-auth.googleplex.com/auth&approval_prompt=force&client_id=440925447803-avn2sj1kc099s0r7v62je5s339mu0am1.apps.googleusercontent.com&hl=en&from_login=1&as=-760f476eeaec11b8&pli=1&authuser=0"
		elog "    (c) run the command mentioned on the server"
		elog "    (d) on the client, connect to the server"
		elog
		elog "Configuration settings you might want to be aware of:"
		elog "  ~/.${PN}-session - shell script to start your session"
		elog "  /etc/init.d/${PN} - script to auto-restart server"
	fi
}
