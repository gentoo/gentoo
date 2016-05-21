# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Pretty-print hashes and arrays before diffing them in MiniTest"
HOMEPAGE="https://github.com/adammck/minitest-pretty_diff"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib:. -e 'require "minitest/autorun"; Dir["test/test_*.rb"].each{|f| require f}' || die
}
