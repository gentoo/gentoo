# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

RUBY_FAKEGEM_GEMSPEC="rake-compiler.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provide a standard and simplified way to build and package Ruby extensions"
HOMEPAGE="https://github.com/luislavena/rake-compiler"
LICENSE="MIT"

SRC_URI="https://github.com/luislavena/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/rake"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

USE_RUBY="ruby25 ruby26 ruby27" ruby_add_bdepend "test? ( dev-util/cucumber dev-ruby/rspec:2 )"

all_ruby_prepare() {
	# Make sure the right rspec version is used in cucumber.
	sed -i -e "1igem 'rspec', '~>2.0'" features/support/env.rb || die

	# Avoid failing features for native gems, this also fails with rubygems
	sed -i -e '/generate native gem/,$ s:^:#:' features/package.feature || die
}

each_ruby_test() {
	# Skip cucumber for new ruby versions (not ready yet)
	case ${RUBY} in
		*ruby25|*ruby26|*ruby27)
			RSPEC_VERSION=3 ruby-ng_rspec
			ruby-ng_cucumber
			;;
		*)
			RSPEC_VERSION=3 ruby-ng_rspec
			;;
	esac
}
