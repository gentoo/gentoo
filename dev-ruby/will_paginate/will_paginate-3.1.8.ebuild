# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Most awesome pagination solution for Ruby"
HOMEPAGE="https://github.com/mislav/will_paginate/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~x86-macos"
IUSE=""

all_ruby_prepare() {
	# Remove tests for unpackaged ORMs
	rm -f spec/finders/{sequel,mongoid,data_mapper}* || die
}

ruby_add_bdepend "
	test? (
		dev-ruby/rails
		dev-ruby/mocha
	)"
