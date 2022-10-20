# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

#RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="rspec-rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="RSpec's official Ruby on Rails plugin"
HOMEPAGE="https://rspec.info/"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	|| ( dev-ruby/activesupport:7.0 dev-ruby/activesupport:6.1 )
	|| ( dev-ruby/actionpack:7.0 dev-ruby/actionpack:6.1 )
	|| ( dev-ruby/railties:7.0 dev-ruby/railties:6.1 )
	>=dev-ruby/rspec-3.11:3"

# Depend on the package being already installed for tests, because
# requiring ammeter will load it, and we need a consistent set of rspec
# and rspec-rails for that to work.
ruby_add_bdepend "test? (
	>=dev-ruby/capybara-2.2.0
	>=dev-ruby/ammeter-1.1.5
	~dev-ruby/rspec-rails-${PV}
)"

all_ruby_prepare() {
	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	echo "--require spec_helper" > .rspec || die

	# Avoid bundler-specific specs.
	rm -f spec/sanity_check_spec.rb || die

	# Avoid broken controller generator specs for now.
	rm -fr spec/generators/rspec || die

	# Test with a compatible rails version
	#sed -i -e '1igem "rails", "<7.0"' spec/spec_helper.rb || die

	# Fix gemspec.
	sed -e 's/git ls-files --/find */' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
