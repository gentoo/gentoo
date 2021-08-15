# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

# There are also cucumber features. They require a Rails project with
# factory girl which we don't have packaged yet.
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber-rails.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios for Rails"
HOMEPAGE="https://cucumber.io/"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE=""

# Restrict tests since Appraisal is now mandatory to manage different
# rails versions, even for the specs.
RESTRICT="test"
#ruby_add_bdepend "
#	test? (
#		>=dev-ruby/ammeter-0.2.2
#		>=dev-ruby/rspec-rails-2.7.0:2
#	)"

ruby_add_rdepend "
	>=dev-util/cucumber-3.0.2 <dev-util/cucumber-6
	>=dev-ruby/nokogiri-1.8
	>=dev-ruby/capybara-2.18:* <dev-ruby/capybara-4:*
	>=dev-ruby/rails-5.0:* <dev-ruby/rails-7:*
	>=dev-ruby/mime-types-3.2:3
"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
