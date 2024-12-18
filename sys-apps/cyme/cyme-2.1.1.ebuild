# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[nusb]='https://github.com/kevinmehall/nusb;3c8ba0a1aadacec8371b6d14deb31c95d3c30602;nusb-%commit%'
)

inherit cargo

DESCRIPTION="List system USB buses and devices; a modern cross-platform \`lsusb\`"
HOMEPAGE="https://github.com/tuna-f1sh/cyme/"
SRC_URI="
	https://github.com/tuna-f1sh/cyme/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${P}-crates.tar.xz
	"
fi

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	LGPL-2+ MIT MPL-2.0 Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="/usr/bin/cyme"

src_prepare() {
	default

	# siiigh
	local nusb=( "${WORKDIR}"/nusb-* )
	sed -i -e "/^nusb/s&git.*&path = \"${nusb}/\" }&" Cargo.toml || die
}
