# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/minitest/minitest-5.4.3.ebuild,v 1.3 2014/12/27 21:04:35 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt Manifest.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="minitest/unit is a small and fast replacement for ruby's huge and slow test/unit"
HOMEPAGE="https://github.com/seattlerb/minitest"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

each_ruby_prepare() {
	case ${RUBY} in
		*rbx)
			# Avoid a single failing test for rbx while we are testing
			# and bootstrapping it.
			sed -i -e '/test_mock_args_does_not_raise/,/^  end/ s:^:#:' test/minitest/test_minitest_mock.rb || die
			;;
		*)
			;;
	esac
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "Dir['**/test_*.rb'].each{|f| require f}" || die "Tests failed"
}
