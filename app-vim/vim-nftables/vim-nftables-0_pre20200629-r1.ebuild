# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_ID="26f8a506c6f3e41f1e4a8d6aa94c9a79a666bbff"

DESCRIPTION="vim plugin: nftables syntax and indent"
HOMEPAGE="https://github.com/nfnty/vim-nftables"
SRC_URI="https://github.com/nfnty/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/vim-nftables-0_pre2020062901-no-expandtab.patch"
)

src_prepare() {
	default

	# will install license file by default
	rm LICENSE || die
}
