# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/json/json-20130830.ebuild,v 1.1 2013/08/30 18:06:06 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: a better JSON for Vim"
HOMEPAGE="https://github.com/elzr/vim-json/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	rm *-test.* || die
}
