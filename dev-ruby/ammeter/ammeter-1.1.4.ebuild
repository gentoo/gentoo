# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Write specs for your Rails 3+ generators"
HOMEPAGE="https://github.com/alexrothenberg/ammeter"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Restrict tests since they now require the specific rspec version to be
# provided in an environment variable.
#RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/activesupport-3.0:*
	>=dev-ruby/railties-3.0:*
	>=dev-ruby/rspec-rails-2.2:*
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rails-4.0
		>=dev-ruby/uglifier-1.3
		>=dev-ruby/rake-0.10
		>=dev-ruby/coffee-rails-4.0
		>=dev-ruby/sass-rails-4.0
		>=dev-ruby/jquery-rails-3.0
		dev-util/cucumber
		dev-util/aruba
		dev-ruby/sqlite3
		dev-ruby/bundler
	)"

all_ruby_prepare() {
	# fix the gemspec; we remove the version dependencies from there, as
	# it requires _older_ versions of its dependencies.. it doesn't
	# really seem to be the case though. Also remove the references to
	# git ls-files to avoid calling it.
	sed -i \
		-e '/git ls-files/d' \
		-e '/\(cucumber\|aruba\)/s:,.*$::' \
		${RUBY_FAKEGEM_GEMSPEC} || die

	# haml-rails is not packaged
	sed -i -e '/haml-rails/d' ${RUBY_FAKEGEM_GEMSPEC} Gemfile || die
	rm -f spec/ammeter/rspec/generator/matchers/have_correct_syntax_spec.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec ${RUBY} -S rspec-3 spec || die
}
