# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/unf_ext/extconf.rb)

inherit ruby-fakegem multilib

DESCRIPTION="Unicode Normalization Form support library for CRuby"
HOMEPAGE="https://github.com/knu/ruby-unf_ext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
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
