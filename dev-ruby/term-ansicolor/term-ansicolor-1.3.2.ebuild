# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/term-ansicolor/term-ansicolor-1.3.2.ebuild,v 1.2 2015/06/28 20:30:58 maekke Exp $

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.rdoc"

RUBY_FAKEGEM_GEMSPEC="term-ansicolor.gemspec"

# don't install a cdiff wrapper, collides with app-misc/colordiff (bug
# #310073).
RUBY_FAKEGEM_BINWRAP="decolor"

inherit ruby-fakegem

DESCRIPTION="Small Ruby library that colors strings using ANSI escape sequences"
HOMEPAGE="https://flori.github.io/term-ansicolor/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/tins-1.0"

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/*_test.rb || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
