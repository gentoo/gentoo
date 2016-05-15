# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils vim-plugin

DESCRIPTION="vim plugin: Syntax highlighting, filetype detection, folding, macros, and templates for Csound files"
HOMEPAGE="http://www.eumus.edu.uy/docentes/jure/csound/vim/"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-doc.patch
}
