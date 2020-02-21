# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERSIONS=(
	192k
	256k
	512k
	aranym
)

DESCRIPTION="Single-user single-tasking operating system for 32-bit Atari computer emulators"
HOMEPAGE="http://emutos.sourceforge.net"
SRC_URI=$(printf "mirror://sourceforge/emutos/${PN}-%s-${PV}.zip\n" "${VERSIONS[@]}")
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN}

	doins */*.img
	use debug && doins */*.sym

	local VERSION
	for VERSION in "${VERSIONS[@]}"; do
		newdoc "${PN}-${VERSION}-${PV}"/readme.txt readme-"${VERSION}".txt
	done

	dodoc "${PN}-512k-${PV}"/doc/{announce,authors,bugs,changelog,emudesk,incompatible,status,todo,xhdi}.txt
}
