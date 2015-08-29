# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

# Disable default binwraps
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

# Tests need to be verified
# Two tests are failing
# test_assert_nothing_thrown(Test::Unit::TC_Assertions):
# test_assert_throws(Test::Unit::TC_Assertions):
RESTRICT=test

DESCRIPTION="Nathaniel Talbott's originial test-unit"
HOMEPAGE="http://test-unit.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

ruby_add_rdepend ">=dev-ruby/hoe-1.5.1"

each_ruby_test() {
	cd test || die
	${RUBY} -I../lib:.. -S testrb test_*.rb || die
}
