# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Perl omni completion"
HOMEPAGE="https://github.com/c9s/perlomni.vim"
SRC_URI="https://github.com/c9s/${PN}.vim/archive/v${PV}.zip -> ${P}.zip"
LICENSE="vim.org"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="
	app-arch/unzip
	dev-lang/perl"

S="${WORKDIR}/${PN}.vim-${PV}"

src_prepare() {
	default
	rm -v Makefile config.mk README.mkd README.mkd.old win32-install.bat TODO || die
}

src_compile() {
	:;
}
