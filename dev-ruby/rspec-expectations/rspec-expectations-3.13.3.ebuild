# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-expectations"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

SUBVERSION="$(ver_cut 1-2)"

ruby_add_rdepend ">=dev-ruby/diff-lcs-1.2.0 =dev-ruby/diff-lcs-1*
	=dev-ruby/rspec-support-${SUBVERSION}*"

ruby_add_bdepend "test? (
		>=dev-ruby/rspec-mocks-3.2.0:3
		>=dev-ruby/rspec-support-3.5.0:3
	)"

all_ruby_prepare() {
	# Don't set up bundler: it doesn't understand our setup.
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Fix minitest deprecation
	sed -i -e 's/MiniTest/Minitest/' spec/rspec/expectations/minitest_integration_spec.rb || die

	# Remove the Gemfile to avoid running through 'bundle exec'
	rm -f Gemfile || die

	# fix up the gemspecs
	sed -i \
		-e '/git ls/d' \
		-e '/add_development_dependency/d' \
		"${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid specs failing with newer diff-lcs. Already fixed upstream.
	rm -f spec/rspec/matchers/dsl_spec.rb \
	   spec/rspec/matchers/built_in/{compound,have_attributes,include}_spec.rb || die

	sed -e '/simplecov/,/^end/ s:^:#:' \
		-i spec/spec_helper.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby34)
			# Avoid tests failing on ruby34. Should be fixed upstream.
			rm -f spec/rspec/matchers/aliases_spec.rb \
			   spec/rspec/matchers/built_in/{change,eq,has,captures,start_and_end_with}_spec.rb \
			   spec/rspec/matchers/english_phrasing_spec.rb || die
			;;
	esac
}
