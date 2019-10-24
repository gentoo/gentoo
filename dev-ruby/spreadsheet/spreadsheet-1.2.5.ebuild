# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

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
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend ">=dev-ruby/ruby-ole-1.0"

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='.+.rb' --exclude='suite\.rb' test/
}
