# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/exheres-syntax/exheres-syntax-20080908.ebuild,v 1.1 2008/09/08 09:11:31 coldwind Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="http://www.exherbo.org/"
SRC_URI="http://dev.exherbo.org/~ahf/pub/software/releases/${PN}/${P}.tar.bz2"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"
