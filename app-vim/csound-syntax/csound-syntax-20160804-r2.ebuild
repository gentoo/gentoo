# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: set of tools for editing Csound files with vim"
HOMEPAGE="https://github.com/luisjure/csound-vim"

LICENSE="MIT"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}"

PATCHES=( "${FILESDIR}/${PN}-doc.patch" )

RDEPEND="!media-sound/csound[vim-syntax]"
