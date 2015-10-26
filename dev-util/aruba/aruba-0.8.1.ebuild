# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="aruba.gemspec"

inherit ruby-fakegem

DESCRIPTION="Cucumber steps for driving out command line applications"
HOMEPAGE="https://github.com/cucumber/aruba"
LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} test? ( sys-devel/bc )"
RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/childprocess-0.5.6 =dev-ruby/childprocess-0.5*
	>=dev-ruby/contracts-0.9:0
	>=dev-ruby/rspec-expectations-2.99:2
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

	# Remove references to git ls-files.
	sed -i -e '/git ls-files/d' aruba.gemspec || die

	# Avoid scenarios making broken assumptions on ${HOME}
	sed -i -e '/Scenario: Use ~ in path/i @wip' \
			features/api/core/expand_path.feature || die
	rm -f features/configuration/home_directory.feature || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	RUBYLIB="$(pwd)/lib" ruby-ng_cucumber
}
