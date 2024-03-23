# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

# There are specs and features but they all require configured databases.
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Strategies for cleaning databases"
HOMEPAGE="https://github.com/DatabaseCleaner/database_cleaner"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend "dev-ruby/database_cleaner-active_record:2.1"
