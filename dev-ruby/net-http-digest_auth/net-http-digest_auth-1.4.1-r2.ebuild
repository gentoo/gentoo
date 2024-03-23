# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="An implementation of RFC 2617 - Digest Access Authentication"
HOMEPAGE="https://github.com/drbrain/net-http-digest_auth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
