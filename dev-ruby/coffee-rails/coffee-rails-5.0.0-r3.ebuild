# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Coffee Script adapter for the Rails asset pipeline"
HOMEPAGE="https://github.com/rails/coffee-rails"
SRC_URI="https://github.com/rails/coffee-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

ruby_add_rdepend "
	>=dev-ruby/coffee-script-2.2.0
	<dev-ruby/railties-7.2:*
"

# sprockets:3 for https://github.com/rails/coffee-rails/issues/122
ruby_add_bdepend "test? ( dev-ruby/rack-session:1 dev-ruby/sprockets-rails dev-ruby/sprockets:3 )"

all_ruby_prepare() {
	# Avoid dependency on git and bundler.
	sed -i -e 's/git ls-files/echo/' \
		-e '/bundler/I s:^:#:' Rakefile || die

	# Make sure a consistent rails version is loaded.
	sed -e '4igem "railties", "<7.2" ; gem "sprockets", "<4"; gem "rack-session", "<2"' \
		-e '/bundler/ s:^:#:' \
		-i test/test_helper.rb || die

	# Avoid generator tests which appear to be broken.
	rm -f test/{controller,scaffold}_generator_test.rb || die
}
