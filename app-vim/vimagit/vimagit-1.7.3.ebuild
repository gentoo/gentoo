# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: ease your git workflow within vim"
HOMEPAGE="https://github.com/jreybert/vimagit"
SRC_URI="https://github.com/jreybert/vimagit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="dev-vcs/git"

DOCS=( README.md Changelog )
