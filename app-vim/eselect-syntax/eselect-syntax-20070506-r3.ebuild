# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: eselect syntax highlighting, filetype and indent settings"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="vim"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

VIM_PLUGIN_HELPFILES="${PN}"
VIM_PLUGIN_MESSAGES="filetype"
