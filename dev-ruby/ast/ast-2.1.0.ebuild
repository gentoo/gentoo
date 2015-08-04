# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ast/ast-2.1.0.ebuild,v 1.1 2015/08/04 04:46:59 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

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
