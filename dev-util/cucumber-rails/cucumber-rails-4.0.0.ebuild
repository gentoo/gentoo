# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

# There are also cucumber features. They require a Rails project with
# factory girl which we don't have packaged yet.
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber-rails.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios for Rails"
HOMEPAGE="https://cucumber.io/"
SRC_URI="https://github.com/cucumber/cucumber-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Ruby"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/ammeter-0.2.2
		>=dev-ruby/appraisal-2.4.1:2
		dev-util/aruba:2
		dev-ruby/database_cleaner:0
	)"

ruby_add_rdepend "
	>=dev-ruby/capybara-3.25:3
	>=dev-util/cucumber-5 <dev-util/cucumber-11
	>=dev-ruby/rails-6.1:* <dev-ruby/rails-9:*
"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
