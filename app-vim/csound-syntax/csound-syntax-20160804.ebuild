# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vim-plugin

DESCRIPTION="set of tools for editing Csound files with vim"
HOMEPAGE="https://github.com/luisjure/csound"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

PATCHES=( "${FILESDIR}"/${P}-doc.patch )

src_prepare() {
	rm LICENSE README.md || die
	default
}
