# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_GEMSPEC="term-ansicolor.gemspec"

inherit ruby-fakegem

DESCRIPTION="Small Ruby library that colors strings using ANSI escape sequences"
HOMEPAGE="https://github.com/flori/term-ansicolor"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"

ruby_add_rdepend ">=dev-ruby/tins-1.0"

all_ruby_prepare() {
	sed -e '/simplecov/I s:^:#:' \
		-i tests/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:tests -e 'Dir["tests/*_test.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
