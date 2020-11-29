# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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
#  curl -q https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-amd64/Packages | grep ^Filename

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PLOCALES="am ar bg bn ca cs da de el en_GB en es_419 es et fa fil fi fr gu he hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt_BR pt_PT ro ru sk sl sr sv sw ta te th tr uk vi zh_CN zh_TW"

inherit unpacker eutils python-single-r1 l10n

DESCRIPTION="access remote computers via Chrome!"
PLUGIN_URL="https://chrome.google.com/remotedesktop"
HOMEPAGE="https://support.google.com/chrome/answer/1649523 ${PLUGIN_URL}"
BASE_URI="https://dl.google.com/linux/chrome-remote-desktop/deb/pool/main/c/${PN}/${PN}_${PV}"
SRC_URI="amd64? ( ${BASE_URI}_amd64.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="xrandr"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="bindist mirror"

# All the libs this package links against.
RDEPEND="app-admin/sudo
	${PYTHON_DEPS}
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
	x11-apps/xdpyinfo
	x11-apps/setxkbmap
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
# TODO: Look at switching to xf86-video-dummy & xf86-input-void instead of xvfb.
RDEPEND+="
	xrandr? ( x11-apps/xrandr )
	x11-base/xorg-server[xvfb]"
DEPEND=""

S=${WORKDIR}

QA_PREBUILT="/opt/google/chrome-remote-desktop/*"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-44.0.2403.44-always-sudo.patch #541708
	cd opt/google/chrome-remote-desktop
	python_fix_shebang chrome-remote-desktop

	cd remoting_locales
	rm fake-bidi* || die
	PLOCALES=${PLOCALES//_/-} l10n_find_plocales_changes "${PWD}" '' '.pak'
}

src_install() {
	pushd opt/google/chrome-remote-desktop/remoting_locales >/dev/null || die
	rm_pak() { local l=${1//_/-}; rm "${l}.pak" "${l}.pak.info"; }
	l10n_for_each_disabled_locale_do rm_pak
	popd >/dev/null

	insinto /etc
	doins -r etc/opt

	insinto /opt
	doins -r opt/google
	chmod a+rx "${ED}"/opt/google/${PN}/* || die
	fperms +s /opt/google/${PN}/user-session

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
		elog "    (b) run ${EPREFIX}opt/google/chrome-remote-desktop/start-host --help to get the auth URL"
		elog "    (c) when it redirects you to a blank page, look at the URL for a code=XXX field"
		elog "    (d) run start-host again, and past the code when asked for an authorization code"
		elog "    (e) on the client, connect to the server"
		elog
		elog "Configuration settings you might want to be aware of:"
		elog "  ~/.${PN}-session - shell script to start your session"
		elog "  /etc/init.d/${PN} - script to auto-restart server"
	fi
}
