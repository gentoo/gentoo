# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/itchyny/lightline.vim/"
else
	# LIGHTLINE_COMMIT=
	SRC_URI="https://github.com/itchyny/lightline.vim/archive/${LIGHTLINE_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}.vim-${LIGHTLINE_COMMIT}"
fi

DESCRIPTION="vim plugin: A light and configurable statusline/tabline"
HOMEPAGE="https://github.com/itchyny/lightline.vim/"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}"
