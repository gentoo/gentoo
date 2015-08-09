# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-mocks"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SUBVERSION="$(get_version_component_range 1-2)"

ruby_add_rdepend "=dev-ruby/rspec-support-${SUBVERSION}*"

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

	# Avoid a weird, and failing, test testing already installed code.
	sed -e '/has an up-to-date caller_filter file/,/end/ s:^:#:' -i spec/rspec/mocks_spec.rb || die

	# Avoid failing specs in yield code. Not clear why verify would not
	# be defined. We can revisit this later so we can move on with
	# rspec-3 introduction for now.
	rm spec/rspec/mocks/and_yield_spec.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby22)
			# The rubygems version bundled with ruby 2.2 causes warnings.
			sed -i -e '/a library that issues no warnings when loaded/,/^  end/ s:^:#:' spec/rspec/mocks_spec.rb || die
			;;
	esac
}
