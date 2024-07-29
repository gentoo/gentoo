# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MASTER_COMMIT_HASH="31823f830843385f53a3da7a5bfaf678494383c4"

DESCRIPTION="vim plugin: use hoogle within vim"
HOMEPAGE="https://github.com/Twinside/vim-hoogle"
SRC_URI="https://github.com/Twinside/${PN}/archive/${MASTER_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MASTER_COMMIT_HASH}"

LICENSE="vim.org"
KEYWORDS="~amd64 ~x86"
