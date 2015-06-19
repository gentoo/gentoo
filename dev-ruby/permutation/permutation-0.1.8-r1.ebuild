# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/permutation/permutation-0.1.8-r1.ebuild,v 1.2 2015/01/26 18:30:25 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGES README"

inherit multilib ruby-fakegem

DESCRIPTION="Library to perform different operations with permutations of sequences (strings, arrays, etc.)"
HOMEPAGE="http://flori.github.com/permutation"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die
}
