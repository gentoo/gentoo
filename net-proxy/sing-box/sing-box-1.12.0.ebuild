# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The universal proxy platform"
HOMEPAGE="https://github.com/SagerNet/sing-box"

SRC_URI="https://github.com/SagerNet/sing-box/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/petermuntz/gentoo-distfiles/releases/download/v${PV}/${P}-deps.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+quic +wireguard"

src_compile() {
	local mygotags=()
	use quic && mygotags+=( with_quic )
	use wireguard && mygotags+=( with_wireguard )

	local gotags_str=""
	if [[ ${#mygotags[@]} -gt 0 ]]; then
		gotags_str="-tags $(IFS=,; echo "${mygotags[*]}")"
	fi

	local mygoldsflags="-s -w -X \"github.com/sagernet/sing-box/constant.Version=${PV}\""

	ego build ${gotags_str} -ldflags "${mygoldsflags}" ./cmd/sing-box
}

src_install() {
	dobin sing-box
	dodoc README.md
}
