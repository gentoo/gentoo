# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Minimal mDNS resolver (and announcer) library"
HOMEPAGE="https://videolabs.io"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/videolabs/${PN}"
else
	SRC_URI="https://github.com/videolabs/${PN}/releases/download/${PV}/${P/lib/}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${P/lib/}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		$(meson_feature examples)
		$(meson_feature test tests)
	)
	meson_src_configure
}
