# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/csound-syntax/csound-syntax-3.1.ebuild,v 1.1 2010/10/08 22:25:20 radhermit Exp $

EAPI=3
inherit eutils vim-plugin

DESCRIPTION="vim plugin: Syntax highlighting, filetype detection, folding, macros, and templates for Csound files"
HOMEPAGE="http://www.eumus.edu.uy/docentes/jure/csound/vim/"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-doc.patch
}
