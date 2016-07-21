# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

# Same thing for the docs whose rake target just calls rdoc.
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_EXTRADOC="GUIDE.txt History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Ruby library to read and write spreadsheet documents"
HOMEPAGE="https://rubygems.org/gems/spreadsheet"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend ">=dev-ruby/ruby-ole-1.0"

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='.+.rb' --exclude='suite\.rb' test/
}
