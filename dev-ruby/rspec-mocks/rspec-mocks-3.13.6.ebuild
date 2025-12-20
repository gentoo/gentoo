# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="rspec-mocks.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-mocks"
SRC_URI="https://github.com/rspec/rspec/archive/refs/tags/${PN}-v${PV}.tar.gz -> ${P}-git.tgz"
RUBY_S="rspec-${PN}-v${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

SUBVERSION="$(ver_cut 1-2)"

ruby_add_rdepend "=dev-ruby/rspec-support-${SUBVERSION}*
	>=dev-ruby/diff-lcs-1.2.0 =dev-ruby/diff-lcs-1*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-core-3.12.0:3
		>=dev-ruby/rspec-expectations-2.99.0:3
	)"

all_ruby_prepare() {
	# Don't set up bundler: it doesn't understand our setup.
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# And consequently avoid specs using bundler. This also avoids a
	# circular dependency on aruba.
	rm -f spec/integration/rails_support_spec.rb spec/support/aruba.rb || die

	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	rm .rspec || die

	sed -i -e '1irequire "spec_helper"' spec/rspec/mocks/any_instance_spec.rb || die

	sed -i -e 's/git ls-files --/find */' ${RUBY_FAKEGEM_GEMSPEC} || die
}
