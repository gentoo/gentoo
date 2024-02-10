# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: a vim plugin with Perl omni completion functions"
HOMEPAGE="https://github.com/c9s/perlomni.vim"
SRC_URI="https://github.com/c9s/${PN}.vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.vim-${PV}"

LICENSE="vim.org"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_compile() { :; }
