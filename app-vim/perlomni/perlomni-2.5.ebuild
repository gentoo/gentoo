# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: a vim plugin with Perl omni completion functions"
HOMEPAGE="https://github.com/c9s/perlomni.vim"
SRC_URI="https://github.com/c9s/${PN}.vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim.org"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="
	app-arch/unzip
	dev-lang/perl"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}.vim-${PV}"

src_compile() { :; }
