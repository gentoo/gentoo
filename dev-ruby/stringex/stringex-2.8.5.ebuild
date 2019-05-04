# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="https://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="test"

# we could rely on activerecord[sqlite3], but since we do not remove the
# sqlite3 adapter from activerecord when building -sqlite3, it's easier
# to just add another dependency, so the user doesn't have to change the
# USE flags at all.
ruby_add_bdepend "
	test? (
		dev-ruby/i18n:1
		dev-ruby/redcloth
		dev-ruby/test-unit:2
		>=dev-ruby/activerecord-3
		dev-ruby/sqlite3 )"

all_ruby_prepare() {
	sed -i -e '1agem "i18n", "~>1.0"' test/test_helper.rb || die
}
