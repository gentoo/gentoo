# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

# Commit Date: 30 May 2018
COMMIT="7f2127b1dfc57811112785985b46ff2289d72334"

DESCRIPTION="vim plugin: comment stuff out"
HOMEPAGE="https://github.com/tpope/vim-commentary"
SRC_URI="https://github.com/tpope/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
