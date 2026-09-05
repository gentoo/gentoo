# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C++23 math expression parsing and evaluation library"
HOMEPAGE="https://github.com/AdelKS/ZeCalculator"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AdelKS/ZeCalculator"
else
	SRC_URI="
		https://github.com/AdelKS/ZeCalculator/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ZeCalculator-${PV}"
fi

LICENSE="AGPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		$(meson_use test)
	)

	meson_src_configure
}
