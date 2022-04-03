# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="https://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"
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
		|| ( dev-ruby/activerecord:7.0[sqlite] dev-ruby/activerecord:6.1[sqlite] dev-ruby/activerecord:6.0[sqlite] dev-ruby/activerecord:5.2[sqlite] )
		)"

all_ruby_prepare() {
	# Let tests work with newer rails versions
	sed -i -e 's/update_attributes/update/' test/unit/acts_as_url/adapter/* || die
}
