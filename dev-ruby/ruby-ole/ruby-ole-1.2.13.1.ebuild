# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

# Same thing for the docs whose rake target just calls rdoc.
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby library for easy read/write access to OLE compound documents"
HOMEPAGE="https://github.com/aquasync/ruby-ole"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Account for differences in Ruby 3.4 output of warnings.
	sed -e '/expect/ s/test.logger/.*test.logger.?/' \
		-i test/test_support.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='test.*\.rb' test/
}
