# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="ast.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for working with abstract syntax trees"
HOMEPAGE="https://github.com/whitequark/ast"
SRC_URI="https://github.com/whitequark/ast/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/bacon )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e "/git ls/d" ${PN}.gemspec || die
	sed -i -e "/simplecov/,+11d" -e "/colored_output/d" test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -S bacon -Itest -a || die
}
