# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es-419 es et fa fil fi fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw
	ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="A privacy-first, open-source platform for knowledge sharing and management"
HOMEPAGE="https://github.com/logseq"
SRC_URI="https://github.com/logseq/og/releases/download/${PV}/Logseq-OG-linux-x64-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/Logseq-OG-linux-x64"

LICENSE="AGPL-3"
SLOT="1"
KEYWORDS="-* ~amd64"
IUSE="wayland"

RESTRICT="mirror splitdebug"

RDEPEND="
	!app-editors/logseq-desktop-bin:0
	dev-libs/nss
	dev-libs/openssl:0/3
	media-libs/alsa-lib
	media-libs/mesa
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	virtual/zlib:=
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
	exeinto /opt/logseq-og-desktop
	doexe Logseq-OG chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1

	insinto /opt/logseq-og-desktop
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin \
		v8_context_snapshot.bin version vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set
	# see https://github.com/electron/electron/issues/17972
	fowners root /opt/logseq-og-desktop/chrome-sandbox
	fperms 4711 /opt/logseq-og-desktop/chrome-sandbox

	# Crashpad is included in the package once in a while and when it does, it must be installed.
	# See #903616 and #890595
	[[ -x chrome_crashpad_handler ]] && doins chrome_crashpad_handler

	dosym ../logseq-og-desktop/Logseq-OG /opt/bin/logseq-og

	local exec_extra_flags=()
	if use wayland; then
		exec_extra_flags+=( "--ozone-platform-hint=auto" "--enable-wayland-ime" )
	fi
	make_desktop_entry --eapi9 "/opt/bin/logseq-og" -a "${exec_extra_flags[*]} %U" -n Logseq-OG \
		-i logseq-og -c Office -e "Terminal=false" -e "MimeType=x-scheme-handler/logseq"
	# some releases do not have an icon included, but we dont fail if that happens
	newicon resources/app/icons/logseq.png logseq-og.png || true
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "Upstream has renamed this version of the program to 'Logseq OG' in preparation"
	ewarn "of the new Logseq version 2, which will use a database-based approach for graphs"
	ewarn "instead of file-based."
	ewarn ""
	ewarn "In order to keep your file-based graphs working as expected, you need to migrate"
	ewarn "the application config directory in \$HOME/.config *BEFORE* starting this new"
	ewarn "version for the first time, like so:"
	ewarn " "
	ewarn '      mv -T "$HOME/.config/Logseq" "$HOME/.config/Logseq OG"'
	ewarn " "
	ewarn "This is required so that starting Logseq OG will find your existing graphs."
	elog ""
	elog "The new DB-based Logseq can be installed in parallel to Logseq OG after"
	elog "release, which is expected to happen in 2026."
	elog ""
	elog "Upstream intends to maintain both versions in the future."
	elog "See"
	elog "https://logseq.io/page/b2ad9ce1-9cb7-4436-8083-54cb4516d324/df4dc09d-0a12-4c87-904e-22a9bf4c350a"
	elog "for details."
}
