# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Validate a regular expression string against what ECMA-262 can actually do"
HOMEPAGE="https://github.com/gjtorikian/ecma-re-validator"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

ruby_add_rdepend "dev-ruby/regexp_parser:2"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
}
