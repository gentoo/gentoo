# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: HTML5/SVG omnicomplete function, indent and syntax for Vim"
HOMEPAGE="https://github.com/othree/html5.vim"
SRC_URI="https://github.com/othree/${PN}.vim/archive/${PV}.zip -> ${P}.zip"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}.vim-${PV}"

src_compile() { :; }
