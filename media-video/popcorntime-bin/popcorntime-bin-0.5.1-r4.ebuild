# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="BitTorrent client that includes an integrated media player"
HOMEPAGE="https://github.com/popcorn-time-ru/popcorn-desktop"
SRC_URI="https://github.com/popcorn-time-ru/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-amd64.deb -> ${PF}-amd64.deb"
S="${WORKDIR}"

LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL-1.1 CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror"

RDEPEND="
	dev-libs/nwjs[sdk(-)]
"

QA_PREBUILT="opt/Popcorn-Time/*"

src_install() {
	doicon -s 256 "usr/share/icons/butter.png"

	domenu usr/share/applications/Popcorn-Time.desktop

	local DESTDIR="/opt/Popcorn-Time"
	pushd "opt/Popcorn-Time" || die

	nwjs_files=(
		chromedriver
		chrome_crashpad_handler
		icudtl.dat
		lib
		locales
		minidump_stackwalk
		nw
		nw_100_percent.pak
		nw_200_percent.pak
		nwjc
		resources.pak
		v8_context_snapshot.bin
	)

	for file in ${nwjs_files[@]}; do
		dosym "../nwjs/${file}" "${DESTDIR}/${file}"
	done

	exeinto "${DESTDIR}"
	doexe Popcorn-Time

	insinto "${DESTDIR}"
	doins package.json git.json
	insopts -m0755
	doins -r src node_modules

	dosym "${DESTDIR}"/Popcorn-Time /opt/bin/Popcorn-Time

	popd || die
}
