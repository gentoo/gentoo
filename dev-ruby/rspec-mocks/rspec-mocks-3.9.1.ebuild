# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

#RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="rspec-mocks.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-mocks"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SUBVERSION="$(ver_cut 1-2)"

ruby_add_rdepend "=dev-ruby/rspec-support-${SUBVERSION}*
	>=dev-ruby/diff-lcs-1.2.0 =dev-ruby/diff-lcs-1*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-core-3.3.0:3
		>=dev-ruby/rspec-expectations-2.99.0:3
	)"

all_ruby_prepare() {
	# Don't set up bundler: it doesn't understand our setup.
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Remove the Gemfile to avoid running through 'bundle exec'
	rm Gemfile || die

	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	rm .rspec || die

	sed -i -e '1irequire "spec_helper"' spec/rspec/mocks/any_instance_spec.rb || die

	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
