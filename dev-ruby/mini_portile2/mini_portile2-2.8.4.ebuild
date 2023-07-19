# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

inherit ruby-fakegem

DESCRIPTION="Simplistic port-like solution for developers"
HOMEPAGE="https://github.com/flavorjones/mini_portile"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
IUSE=""

BDEPEND="test? ( dev-util/cmake )"

ruby_add_bdepend "test? (
	dev-ruby/minitar
	dev-ruby/minitest-hooks
	dev-ruby/net-ftp
	dev-ruby/webrick
)"

each_ruby_test() {
	${RUBY} -w -W2 -I. -Ilib -e 'Dir["test/test_*.rb"].map{|f| require f}' || die
}
