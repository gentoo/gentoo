# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="New classes and extensions to core library classes"
HOMEPAGE="https://github.com/chriswailes/filigree"
LICENSE="UoI-NCSA"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib:.:test test/ts_filigree.rb || die
}
