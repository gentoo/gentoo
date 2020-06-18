# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_ID="ec09292c0d7762c8675f9b08f473af8bd9803afc"

DESCRIPTION="vim plugin: "
HOMEPAGE="https://github.com/egberts/vim-nftables"
SRC_URI="https://github.com/egberts/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	# will install license file by default
	rm LICENSE || die
}
