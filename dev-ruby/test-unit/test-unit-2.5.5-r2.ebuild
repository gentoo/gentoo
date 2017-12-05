# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="TODO README.textile"

inherit ruby-fakegem

DESCRIPTION="An improved version of the Test::Unit framework from Ruby 1.8"
HOMEPAGE="http://test-unit.rubyforge.org/"

LICENSE="Ruby"
SLOT="2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

each_ruby_test() {
	${RUBY} test/run-test.rb || die "testsuite failed"
}

all_ruby_install() {
	all_fakegem_install

	newbin "${FILESDIR}"/testrb testrb-2
}
