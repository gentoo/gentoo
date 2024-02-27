# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es-419 es et fa fil fi fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw
	ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="A privacy-first, open-source platform for knowledge sharing and management."
HOMEPAGE="https://github.com/logseq/logseq"
SRC_URI="https://github.com/logseq/logseq/releases/download/${PV}/logseq-linux-x64-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/Logseq-linux-x64"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror splitdebug"

RDEPEND="
	dev-libs/nss
	dev-libs/openssl:0/3
	media-libs/alsa-lib
	media-libs/mesa
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"
BDEPEND="
	app-arch/unzip
"

QA_PREBUILT="*"

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	pushd locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die
}

src_install() {
	exeinto /opt/logseq-desktop
	doexe Logseq chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1

	insinto /opt/logseq-desktop
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin \
		v8_context_snapshot.bin version vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set
	# see https://github.com/electron/electron/issues/17972
	fowners root /opt/logseq-desktop/chrome-sandbox
	fperms 4711 /opt/logseq-desktop/chrome-sandbox

	# Crashpad is included in the package once in a while and when it does, it must be installed.
	# See #903616 and #890595
	[[ -x chrome_crashpad_handler ]] && doins chrome_crashpad_handler

	dosym ../logseq-desktop/Logseq /opt/bin/logseq

	make_desktop_entry "/opt/bin/logseq %U" Logseq logseq Office \
		"StartupWMClass=logseq\nTerminal=false\nMimeType=x-scheme-handler/logseq"
	# some releases do not have an icon included, but we dont fail if that happens
	doicon resources/app/icons/logseq.png || true
}
