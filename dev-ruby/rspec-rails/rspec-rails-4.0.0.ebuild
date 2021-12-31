# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

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

ruby_add_rdepend ">=dev-ruby/activesupport-4.2:*
	>=dev-ruby/actionpack-4.2:*
	>=dev-ruby/railties-4.2:*
	>=dev-ruby/rspec-3.9:3"

# Depend on the package being already installed for tests, because
# requiring ammeter will load it, and we need a consistent set of rspec
# and rspec-rails for that to work.
ruby_add_bdepend "test? (
	>=dev-ruby/capybara-2.2.0
	>=dev-ruby/ammeter-1.1.2
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

	# Fix gemspec
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
