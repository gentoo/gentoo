# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/unf_ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Unicode Normalization Form support library for CRuby"
HOMEPAGE="https://github.com/knu/ruby-unf_ext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/test-unit-2.5.1-r1
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/ s:^:#:' Rakefile test/helper.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 test/test_*.rb
}
