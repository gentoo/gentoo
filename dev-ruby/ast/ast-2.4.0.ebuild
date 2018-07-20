# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A library for working with abstract syntax trees"
HOMEPAGE="https://github.com/whitequark/ast"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
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
