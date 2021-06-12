# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERSIONS=(
	192k
	256k
	512k
	aranym
)

DESCRIPTION="Single-user single-tasking operating system for 32-bit Atari computer emulators"
HOMEPAGE="https://emutos.sourceforge.net"
SRC_URI=$(printf "mirror://sourceforge/emutos/${PN}-%s-${PV}.zip\n" "${VERSIONS[@]}")
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/share/${PN}
	doins */*.{img,sym}

	local version
	for version in "${VERSIONS[@]}"; do
		newdoc ${PN}-${version}-${PV}/readme.txt readme-${version}.txt
	done

	dodoc ${PN}-512k-${PV}/doc/{announce,authors,bugs,changelog,emudesk,incompatible,status,todo,xhdi}.txt
}
