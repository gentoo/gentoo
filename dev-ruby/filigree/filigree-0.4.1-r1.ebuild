# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="New classes and extensions to core library classes"
HOMEPAGE="https://github.com/chriswailes/filigree"
LICENSE="UoI-NCSA"

SLOT="0"
KEYWORDS="~amd64"

each_ruby_test() {
	${RUBY} -Ilib:.:test test/ts_filigree.rb || die
}
