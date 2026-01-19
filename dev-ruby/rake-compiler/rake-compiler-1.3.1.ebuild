# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="rake-compiler.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provide a standard and simplified way to build and package Ruby extensions"
HOMEPAGE="https://github.com/rake-compiler/rake-compiler"
SRC_URI="https://github.com/rake-compiler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend "dev-ruby/rake"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

USE_RUBY="ruby32 ruby33 ruby34" ruby_add_bdepend "test? ( dev-util/cucumber )"

all_ruby_prepare() {
	# Avoid failing features for native gems, this also fails with rubygems
	sed -i -e '/generate native gem/,$ s:^:#:' features/package.feature || die

	# Fix compatibility with newer cucumber versions. The not syntax has
	# been supported since cucumber 3.x.
	sed -i -e "s/~@java/'not @java'/" cucumber.yml || die

	# Fix compatibility with newer rspec versions.
	sed -i -e 's/be_true/be true/ ; s/be_false/be false/' features/step_definitions/*.rb || die
}

each_ruby_test() {
	# Skip cucumber for new ruby versions (not ready yet due to circular dependencies)
	case ${RUBY} in
		*ruby32|*ruby33|*ruby34)
			RSPEC_VERSION=3 ruby-ng_rspec
			ruby-ng_cucumber
			;;
		*)
			RSPEC_VERSION=3 ruby-ng_rspec
			;;
	esac
}
