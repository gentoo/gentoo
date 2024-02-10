# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jpmens/${PN}"
else
	SRC_URI="https://github.com/jpmens/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export bashcompdir=$(get_bashcompdir)
	default
}

src_install() {
	default
	mv "${D}"$(get_bashcompdir)/jo{.bash,} || die
}
