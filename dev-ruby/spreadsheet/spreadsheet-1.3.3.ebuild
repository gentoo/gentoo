# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

RUBY_FAKEGEM_EXTRADOC="GUIDE.md History.md README.md"

RUBY_FAKEGEM_GEMSPEC="spreadsheet.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby library to read and write spreadsheet documents"
HOMEPAGE="https://github.com/zdavatz/spreadsheet"
SRC_URI="https://github.com/zdavatz/spreadsheet/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend "
	dev-ruby/bigdecimal
	>=dev-ruby/ruby-ole-1.0
"

all_ruby_prepare() {
	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='.+.rb' --exclude='suite\.rb' test/
}
