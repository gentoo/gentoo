# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
SRC_URI="https://github.com/jpmens/jo/releases/download/${PV}/${P}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=(
	AUTHORS
	README
)

PATCHES=(
	"${FILESDIR}/jo-1.9-bashcomp.patch"
)

src_prepare() {
	default
	eautoreconf
}
