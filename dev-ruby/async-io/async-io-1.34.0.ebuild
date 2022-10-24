# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRA_DOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides support for asynchonous TCP, UDP, UNIX and SSL sockets"
HOMEPAGE="https://github.com/socketry/async-io"
SRC_URI="https://github.com/socketry/async-io/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend "dev-ruby/async"

ruby_add_bdepend "test? (
	>=dev-ruby/async-container-0.15:0
	>=dev-ruby/async-rspec-1.10:1
	dev-ruby/rack-test
)"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid test dependency on covered
	sed -i -e '/covered/ s:^:#:' spec/spec_helper.rb || die
}
