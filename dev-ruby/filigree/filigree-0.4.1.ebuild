# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

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
