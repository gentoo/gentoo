# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop xdg

DESCRIPTION="Nextcloud Talk Desktop client"
HOMEPAGE="https://github.com/nextcloud-releases/talk-desktop"
SRC_URI="
	https://github.com/nextcloud-releases/talk-desktop/releases/download/v${PV}/Nextcloud.Talk-linux-x64.zip -> ${P}.zip
	https://dev.gentoo.org/~nowa/talk-icon-rounded.svg -> ${PN}-icon.svg
"
S="${WORKDIR}/Nextcloud Talk-linux-x64"

# Electron bundles a bunch of things
LICENSE="
	AGPL-3+ MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 GPL-3 LGPL-2.1 APSL-2
	unRAR OFL-1.1 CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"
RDEPEND="
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	media-video/ffmpeg
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="opt/nextcloud-talk-desktop/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd locales || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	newicon -s scalable "${DISTDIR}/${PN}-icon.svg" nextcloud-talk.svg

	make_desktop_entry --eapi9 \
		'/opt/bin/nextcloud-talk' \
		-d 'nextcloud-talk' \
		-n 'Nextcloud Talk' \
		-i 'nextcloud-talk' \
		-c 'Chat;Network;Office;'

	local DESTDIR="/opt/nextcloud-talk-desktop"

	exeinto "${DESTDIR}"
	doexe chrome-sandbox *.so*
	newexe 'Nextcloud Talk' nextcloud-talk

	insinto "${DESTDIR}"
	doins *.pak *.bin *.json *.dat
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fperms 4755 "${DESTDIR}"/chrome-sandbox

	dosym "../../${DESTDIR}/nextcloud-talk" /opt/bin/nextcloud-talk
}
