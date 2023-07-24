# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="minitest/unit is a small and fast replacement for ruby's huge and slow test/unit"
HOMEPAGE="https://github.com/minitest/minitest"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"

all_ruby_prepare() {
	# Avoid a test dependency on dev-ruby/hoe, leading to circular dependencies
	rm -f test/minitest/test_minitest_test_task.rb || die
}

each_ruby_test() {
	export -n A
	MT_NO_PLUGINS=true ${RUBY} -Ilib:test:. -e "Dir['**/test_*.rb'].each{|f| require f}" || die "Tests failed"
}
