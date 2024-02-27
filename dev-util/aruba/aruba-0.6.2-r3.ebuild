# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="aruba.gemspec"

inherit ruby-fakegem

DESCRIPTION="Cucumber steps for driving out command line applications"
HOMEPAGE="https://github.com/cucumber/aruba"
LICENSE="MIT"

KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~s390 sparc x86"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} test? ( app-alternatives/bc )"
RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/childprocess-0.3.6
	>=dev-ruby/rspec-expectations-2.7:*
	>=dev-util/cucumber-1.1.1"

all_ruby_prepare() {
	# Remove bundler-related code.
	sed -i -e '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die

	# Remove references to git ls-files.
	sed -i -e '/git ls-files/d' aruba.gemspec || die

	sed -i -e "s/~@wip/'not @wip'/" cucumber.yml || die
	sed -i -e 's/~@in-process/not @in-process/' features/support/custom_main.rb || die
}
