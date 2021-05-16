# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_GEMSPEC="aruba.gemspec"

inherit ruby-fakegem

DESCRIPTION="Cucumber steps for driving out command line applications"
HOMEPAGE="https://github.com/cucumber/aruba"
SRC_URI="https://github.com/cucumber/aruba/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE=""

DEPEND="${DEPEND} test? ( sys-devel/bc )"
RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/childprocess-2.0 <dev-ruby/childprocess-5
	>=dev-ruby/contracts-0.16.0:0
	>=dev-ruby/ffi-1.9
	>=dev-ruby/rspec-expectations-3.4:3
	dev-ruby/thor:1
	>=dev-util/cucumber-2.4 <dev-util/cucumber-6"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

all_ruby_prepare() {
	# Remove bundler-related code.
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
	rm Gemfile || die

	sed -i -e '/simplecov/I s:^:#:' \
		-e '/Before/,/^end/ s:^:#:' \
		spec/spec_helper.rb features/support/env.rb || die
	rm -f features/support/simplecov_setup.rb || die

	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid features with minor output differences
	sed -i -e '/Use .aruba. with .Minitest./i@wip' features/01_getting_started_with_aruba/supported_testing_frameworks.feature || die
	sed -i -e '/Failed detection of exact multi-line output/i@wip' features/03_testing_frameworks/cucumber/steps/command/check_output_of_command.feature || die
	sed -i -e '/Create files for Minitest/i@wip' features/06_use_aruba_cli/initialize_project_with_aruba.feature || die

}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	RUBYLIB="$(pwd)/lib" ruby-ng_cucumber
}
