# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A tiny mock and stub object framework for minitest."
HOMEPAGE="https://minite.st/"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/minitest:6
)"

all_ruby_prepare() {
	sed -e '1igem "minitest", "~> 6.0"' \
		-i test/minitest/test_minitest_mock.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/**/test_*.rb"].each { |f| require f }' || die
}
