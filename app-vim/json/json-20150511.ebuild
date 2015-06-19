# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/json/json-20150511.ebuild,v 1.1 2015/06/19 06:48:36 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: a better JSON for Vim"
HOMEPAGE="https://github.com/elzr/vim-json/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	rm *-test.* license.md || die
}
