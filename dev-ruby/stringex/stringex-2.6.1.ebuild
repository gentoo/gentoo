# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_DOC_DIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="https://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

# we could rely on activerecord[sqlite3], but since we do not remove the
# sqlite3 adapter from activerecord when building -sqlite3, it's easier
# to just add another dependency, so the user doesn't have to change the
# USE flags at all.
ruby_add_bdepend "
	test? (
		>=dev-ruby/i18n-0.6.9:0.6
		dev-ruby/redcloth
		dev-ruby/test-unit:2
		>=dev-ruby/activerecord-3
		dev-ruby/sqlite3 )"

all_ruby_prepare() {
	sed -i -e '1agem "i18n", "~>0.6.9"' test/test_helper.rb || die
}

each_ruby_test() {
	# rake seems to break this
	ruby-ng_testrb-2 -Ilib -Itest test/unit/*/*_test.rb test/performance/*_test.rb || die "tests failed"
}
