# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: runs the currently open file through flake8"
HOMEPAGE="https://github.com/nvie/vim-flake8"
SRC_URI="https://github.com/nvie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="dev-python/flake8"
