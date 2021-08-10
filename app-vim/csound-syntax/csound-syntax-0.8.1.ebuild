# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin
MY_P="csound-vim-${PV}"

DESCRIPTION="vim plugin: set of tools for editing Csound files with vim"
HOMEPAGE="https://github.com/luisjure/csound"
SRC_URI="https://github.com/luisjure/csound-vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

PATCHES=( "${FILESDIR}/${PN}-doc.patch" )
