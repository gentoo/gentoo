# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="http://rspec.rubyforge.org/"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/diff-lcs-1.1.3"

ruby_add_bdepend "test? (
		>=dev-ruby/rspec-core-2.99.0:2
		>=dev-ruby/rspec-mocks-2.14.0:2
	)"

all_ruby_prepare() {
	# Don't set up bundler: it doesn't understand our setup.
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Remove the Gemfile to avoid running through 'bundle exec'
	rm Gemfile || die

	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	rm .rspec || die

	# fix up the gemspecs
	sed -i \
		-e '/git ls/d' \
		-e '/add_development_dependency/d' \
		"${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid a weird, and failing, test testing already installed code.
	sed -e '/has an up-to-date caller_filter file/,/end/ s:^:#:' -i spec/rspec/expectations_spec.rb || die
}

each_ruby_prepare() {
	sed -i -e 's/of Fixnum/of Integer/' spec/rspec/expectations/expectation_target_spec.rb spec/rspec/matchers/be_instance_of_spec.rb || die
}
