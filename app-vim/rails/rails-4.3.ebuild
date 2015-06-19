# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/rails/rails-4.3.ebuild,v 1.1 2011/03/10 10:08:38 radhermit Exp $

EAPI=3

inherit vim-plugin

DESCRIPTION="vim plugin: aids developing Ruby on Rails applications"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1567"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=13800 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="rails"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
