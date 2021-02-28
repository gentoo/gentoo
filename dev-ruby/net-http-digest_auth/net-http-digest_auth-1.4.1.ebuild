# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="An implementation of RFC 2617 - Digest Access Authentication"
HOMEPAGE="https://github.com/drbrain/net-http-digest_auth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
