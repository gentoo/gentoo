# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit vim-plugin

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jreybert/vimagit.git"
else
	SRC_URI="https://github.com/jreybert/vimagit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="vim plugin: ease your git workflow within vim"
HOMEPAGE="https://github.com/jreybert/vimagit"
LICENSE="vim"
VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="dev-vcs/git"
