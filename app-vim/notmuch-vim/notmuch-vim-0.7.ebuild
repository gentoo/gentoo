# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/felipec/notmuch-vim.git"
else
	SRC_URI="https://github.com/felipec/notmuch-vim/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="vim plugin: mail client interface using 'notmuch'"
HOMEPAGE="https://github.com/felipec/notmuch-vim"
LICENSE="vim"
VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="|| ( app-editors/vim[ruby] app-editors/gvim[ruby] ) net-mail/notmuch"

DOCS=( doc/notmuch.txt )
