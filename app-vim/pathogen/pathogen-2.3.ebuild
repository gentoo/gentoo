# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/pathogen/pathogen-2.3.ebuild,v 1.2 2015/02/07 02:55:00 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: manage your runtimepath"
HOMEPAGE="https://github.com/tpope/vim-pathogen/ http://www.vim.org/scripts/script.php?script_id=2332"
SRC_URI="https://github.com/tpope/vim-pathogen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86 ~x64-macos"

S=${WORKDIR}/vim-${P}
