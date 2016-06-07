# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: runs the currently open file through flake8"
HOMEPAGE="https://github.com/nvie/vim-flake8"
SRC_URI="https://github.com/nvie/${PN}/archive/${PV}.zip -> ${P}.zip"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="dev-python/flake8"
