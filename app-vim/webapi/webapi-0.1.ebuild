# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/webapi/webapi-0.1.ebuild,v 1.1 2012/08/03 10:25:05 radhermit Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: interface to Web APIs"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=4019"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl"

VIM_PLUGIN_HELPFILES="${PN}.txt"
