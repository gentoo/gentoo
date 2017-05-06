# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: enhanced multi-file search"
HOMEPAGE="https://github.com/wincent/ferret"
SRC_URI="https://github.com/wincent/${PN}/archive/${PV}.zip -> ${P}.zip"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

src_prepare() {
	default
	rm -rvf test.rb doc/.gitignore || die
	# See bug 612282.
	mv ftplugin/qf.vim ftplugin/${PN}qf.vim || die
}
