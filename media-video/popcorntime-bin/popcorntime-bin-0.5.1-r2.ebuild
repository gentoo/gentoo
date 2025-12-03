# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="BitTorrent client that includes an integrated media player"
HOMEPAGE="https://github.com/popcorn-time-ru/popcorn-desktop"
SRC_URI="https://github.com/popcorn-time-ru/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-amd64.deb -> ${PF}-amd64.deb"
S="${WORKDIR}"

LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL-1.1 CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	~dev-libs/nwjs-0.86.0
"

QA_PREBUILT="opt/Popcorn-Time/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/Popcorn-Time/locales" || die
	# No l10n use entries for these langs
	rm ar-XB.pak* en-XA.pak* || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	doicon -s 256 "usr/share/icons/butter.png"

	domenu usr/share/applications/Popcorn-Time.desktop

	local DESTDIR="/opt/Popcorn-Time"
	pushd "opt/Popcorn-Time" || die

	nwjs_files=(
		chrome_crashpad_handler
		icudtl.dat
		lib
		nw
		nw_100_percent.pak
		nw_200_percent.pak
		resources.pak
		v8_context_snapshot.bin
	)

	for file in ${nwjs_files[@]}; do
		dosym ."./nwjs/${file}" "${DESTDIR}/${file}"
	done

	exeinto "${DESTDIR}"
	doexe Popcorn-Time nwjc minidump_stackwalk chromedriver

	insinto "${DESTDIR}"
	doins package.json git.json
	insopts -m0755
	doins -r locales src node_modules

	dosym "${DESTDIR}"/Popcorn-Time /opt/bin/Popcorn-Time

	popd || die
}
