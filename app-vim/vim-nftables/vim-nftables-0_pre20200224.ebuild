# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_ID="01c7b97eff12fd4b624e6efa2c0468163db61ebc"

DESCRIPTION="vim plugin: nftables syntax and indent"
HOMEPAGE="https://github.com/nfnty/vim-nftables"
SRC_URI="https://github.com/nfnty/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	# will install license file by default
	rm LICENSE || die
}
