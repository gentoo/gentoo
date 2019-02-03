# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

# Same thing for the docs whose rake target just calls rdoc.
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_EXTRADOC="GUIDE.md History.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby library to read and write spreadsheet documents"
HOMEPAGE="https://rubygems.org/gems/spreadsheet"
SRC_URI="https://github.com/zdavatz/spreadsheet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend ">=dev-ruby/ruby-ole-1.0"

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='.+.rb' --exclude='suite\.rb' test/
}
