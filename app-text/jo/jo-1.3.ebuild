# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
SRC_URI="https://github.com/jpmens/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	export bashcompdir=$(get_bashcompdir)
	default
}

src_install() {
	default
	mv "${ED}/$(get_bashcompdir)"/jo{.bash,} || die
}
