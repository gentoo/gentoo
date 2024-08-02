# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md TODO.md"
RUBY_FAKEGEM_EXTRAINSTALL="schemas"
RUBY_FAKEGEM_GEMSPEC="json_schema.gemspec"

inherit ruby-fakegem

DESCRIPTION="A JSON Schema V4 and Hyperschema V4 parser and validator"
HOMEPAGE="https://github.com/brandur/json_schema"
SRC_URI="https://github.com/brandur/json_schema/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

ruby_add_bdepend "test? ( dev-ruby/ecma-re-validator )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
	sed -i -e '/^if/,/^end/ s:^:#:' test/test_helper.rb || die

	sed -e '/validates date format successfully/askip "should fail like test after it"' \
		-i test/json_schema/validator_test.rb || die
}
