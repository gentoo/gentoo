# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Wikipedia syntax highlighting"
HOMEPAGE="https://en.wikipedia.org/wiki/Wikipedia:Text_editor_support#Vim"
LICENSE="CC-BY-SA-3.0"
KEYWORDS="amd64 ~hppa ~mips ppc ppc64 x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Wikipedia article
files. Detection is by filename (*.wiki)."

VIM_PLUGIN_MESSAGES="filetype"
