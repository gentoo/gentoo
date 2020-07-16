# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: enhanced multi-file search"
HOMEPAGE="https://github.com/wincent/ferret"
SRC_URI="https://github.com/wincent/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vim"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default

	rm -rv test.rb doc/.gitignore || die
	# See bug 612282.
	mv ftplugin/qf.vim ftplugin/${PN}qf.vim || die
}
