# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_BINDIR="exe"

inherit ruby-fakegem

DESCRIPTION="Cucumber steps for driving out command line applications"
HOMEPAGE="https://github.com/cucumber/aruba"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} test? ( sys-devel/bc )"
RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/childprocess-0.6.3 <dev-ruby/childprocess-4
	>=dev-ruby/contracts-0.9:0
	>=dev-ruby/ffi-1.9
	>=dev-ruby/rspec-expectations-2.99:2
	>=dev-ruby/thor-0.19:0
	>=dev-util/cucumber-1.3.19"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 >=dev-ruby/bcat-0.6.2 )"

all_ruby_prepare() {
	# Remove bundler-related code.
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
	rm Gemfile || die

	sed -i -e '/simplecov/I s:^:#:' \
		-e '/Before/,/^end/ s:^:#:' \
		spec/spec_helper.rb features/support/env.rb || die
	rm -f features/support/simplecov_setup.rb || die
	sed -i -e '1i require "time"' spec/spec_helper.rb || die

	sed -i -e '/Scenario: Default value/i@wip' features/02_configure_aruba/home_directory.feature || die
	sed -i -e '/Use ~ in path/i@wip' features/04_aruba_api/core/expand_path.feature || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	RUBYLIB="$(pwd)/lib" ruby-ng_cucumber
}
