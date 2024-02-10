# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Most awesome pagination solution for Ruby"
HOMEPAGE="https://github.com/mislav/will_paginate/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	# Remove tests for unpackaged ORMs
	rm -f spec/finders/{sequel,mongoid,data_mapper}* || die

	# Use a supported rails version
	sed -e '1igem "activerecord", "<7"; gem "actionpack", "<7"' -i spec/spec_helper.rb || die
}

ruby_add_bdepend "
	test? (
		<dev-ruby/rails-7
		dev-ruby/sqlite3
		dev-ruby/mocha
	)"
