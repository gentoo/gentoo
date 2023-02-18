# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

# There are specs and features but they all require configured databases.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Strategies for cleaning databases using ActiveRecord"
HOMEPAGE="https://github.com/DatabaseCleaner/database_cleaner-active_record"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "
	|| ( dev-ruby/activerecord:6.1 dev-ruby/activerecord:6.0 dev-ruby/activerecord:5.2 )
	dev-ruby/database_cleaner-core:2.0
"
