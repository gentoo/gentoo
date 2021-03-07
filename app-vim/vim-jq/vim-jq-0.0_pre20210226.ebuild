# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT_HASH="0076ef5424894e17f0ab17f4d025a3b519008134"
inherit vim-plugin

DESCRIPTION="vim plugin: Runtime files for app-misc/jq"
HOMEPAGE="https://github.com/bfrg/vim-jq"
SRC_URI="https://github.com/bfrg/vim-jq/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"
