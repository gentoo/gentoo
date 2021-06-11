# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_HASH="5d2496eb5fd4415c7ce062ccbcd53a3f0de93aa3"
DESCRIPTION="vim plugin: Jinja2 syntax highlighting"
HOMEPAGE="https://github.com/Glench/Vim-Jinja2-Syntax/"
SRC_URI="https://github.com/Glench/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
