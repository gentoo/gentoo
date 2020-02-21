# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_ID="aad8540ef56f495baa589f646edc1253db990f1a"

DESCRIPTION="vim plugin: "
HOMEPAGE="https://github.com/nfnty/vim-nftables"
SRC_URI="https://github.com/nfnty/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/vim-nftables-0_pre20200220-extra-keywords.patch"
)

src_prepare() {
	default

	# will install license file by default
	rm LICENSE || die
}
