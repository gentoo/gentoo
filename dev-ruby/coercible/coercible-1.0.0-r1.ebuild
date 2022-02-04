# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Powerful, flexible and configurable coercion library"
HOMEPAGE="https://github.com/solnic/coercible https://rubygems.org/gems/coercible"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/descendants_tracker-0.0.1
	<dev-ruby/descendants_tracker-0.1"
