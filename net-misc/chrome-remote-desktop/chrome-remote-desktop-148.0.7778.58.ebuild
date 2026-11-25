# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Base URL: https://dl.google.com/linux/chrome-remote-desktop/deb/
# Fetch the Release file:
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/Release
# Which gives you the Packages file:
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-i386/Packages
#  https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-amd64/Packages
# And finally gives you the file name:
#  pool/main/c/chrome-remote-desktop/chrome-remote-desktop_148.0.7778.58_amd64.deb
#
# Use curl to find the answer:
#  curl -q https://dl.google.com/linux/chrome-remote-desktop/deb/dists/stable/main/binary-amd64/Packages | grep ^Filename

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB en es-419 es et fa fil fi fr gu he hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw ta te th tr uk vi zh-CN zh-TW"

inherit unpacker python-single-r1 chromium-2

DESCRIPTION="access remote computers via Chrome!"
PLUGIN_URL="https://remotedesktop.google.com"
HOMEPAGE="https://support.google.com/chrome/answer/1649523
	https://remotedesktop.google.com"
BASE_URI="https://dl.google.com/linux/chrome-remote-desktop/deb/pool/main/c/${PN}/${PN}_${PV}"
SRC_URI="amd64? ( ${BASE_URI}_amd64.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="gnome systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="bindist mirror"

# Packages we execute, but don't link.
RDEPEND="app-admin/sudo
	${PYTHON_DEPS}"
# All the libs this package links against.
#
# Note: DEBIAN/control says either pkexec or polkit is required as (r)depends,
# but compatibility with pkexec is not tested on gentoo, so we only support
# polkit for now.
#
# Note: As of May 6, 2026, media-libs/mesa installs libgbm.so.1, which is required
# by chrome-remote-desktop.
#
# Note: There is no guarantee that this package works on non-systemd or non-GNOME
#       environments, because the .deb package itself depends on systemd and gsettings-
#       desktop-schemas. gnome and systemd-related packages are set as conditional
#       packages just for package backward compatibility and for those who wants to try
#       it in such environments.
RDEPEND+="
	>=dev-libs/expat-2
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome? ( gnome-base/gsettings-desktop-schemas )
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
	')
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/mesa
	sys-apps/dbus
	systemd? ( sys-apps/systemd )
	sys-auth/polkit
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/libutempter
	sys-libs/pam
	sys-process/psmisc
	x11-apps/xdpyinfo
	x11-apps/setxkbmap
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/pango"
# Settings we just need at runtime.
# TODO: Look at switching to xf86-video-dummy & xf86-input-void instead of xvfb.
# - The env var (CHROME_REMOTE_DESKTOP_USE_XORG) seems to be stripped before being checked.
# - The Xorg invocation uses absolute paths with -logfile & -config which are rejected.
# - The config takes over the active display in addition to starting up a virtual one.
RDEPEND+="
	x11-base/xorg-server[xvfb]"
# Although DEBIAN/control says xrandr is optional, it's mandatory for xvfb because the buggy
# _launch_xvfb() function in chrome-remote-desktop always fails if xrandr is unavailable,
# as subprocess.call("xrandr", ...) raises an exception in such case.
RDEPEND+="
	x11-apps/xrandr"
BDEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}

QA_PREBUILT="/opt/google/chrome-remote-desktop/*"

PATCHES=(
	"${FILESDIR}"/${PN}-91.0.4472.10-always-sudo.patch #541708
	"${FILESDIR}"/${PN}-148.0.7778.58-fix-xsessions-path.patch
)

src_prepare() {
	default

	gunzip usr/share/doc/${PN}/*.gz || die

	cd opt/google/chrome-remote-desktop
	python_fix_shebang chrome-remote-desktop

	cd remoting_locales
	# These isn't always included.
	rm -f fake-bidi* || die
}

src_install() {
	pushd opt/google/chrome-remote-desktop/remoting_locales >/dev/null || die
	chromium_remove_language_paks
	popd >/dev/null

	insinto /etc
	doins -r etc/opt
	dosym ../opt/chrome/native-messaging-hosts /etc/chromium/native-messaging-hosts #581754

	insinto /opt
	doins -r opt/google
	chmod a+rx "${ED}"/opt/google/${PN}/* || die

	insinto /usr/lib/systemd
	doins -r lib/systemd/system

	insinto /usr/share
	doins -r usr/share/wireplumber

	dodir /etc/pam.d
	dosym system-remote-login /etc/pam.d/${PN}

	dodoc usr/share/doc/${PN}/changelog*

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
}

pkg_setup() {
	python_setup
	chromium_suid_sandbox_check_kernel_config
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
		elog "    (b) open the headless setup wizard on the client:"
		elog "        ${PLUGIN_URL}/headless"
		elog "    (c) proceed with the wizard and run the setup command for Debian Linux"
		elog "    (d) on the client, connect to the server"
		elog
		elog "Configuration settings you might want to be aware of:"
		elog "  ~/.xsession - shell script to start your session"
		elog "  /etc/init.d/${PN} - script to auto-restart server"
		elog
		elog "For example, run the following commands to set up X session for GNOME:"
		elog "  echo -e '#!/bin/sh\\n\\nexec /etc/X11/Sessions/Gnome' > .xsession"
		elog "  chmod +x .xsession"
	fi
}
