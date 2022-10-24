# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Helpers for writing specs against the async gem"
HOMEPAGE="https://github.com/socketry/async-rspec"
SRC_URI="https://github.com/socketry/async-rspec/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend "dev-ruby/rspec:3
	dev-ruby/rspec-files:1
	dev-ruby/rspec-memory:1
"

ruby_add_bdepend "test? (
	dev-ruby/async
	dev-ruby/async-io
)"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid dependency on unpackaged covered
	sed -i -e '/covered/ s:^:#:' spec/spec_helper.rb || die
}
