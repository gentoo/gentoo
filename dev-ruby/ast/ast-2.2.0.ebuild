# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="yard"
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
