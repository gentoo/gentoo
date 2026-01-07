# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="changelog.txt Readme.md"

inherit ruby-fakegem

DESCRIPTION="This library reads and writes .netrc files"
HOMEPAGE="https://github.com/heroku/netrc"
LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	# Avoid broken test that wrongly tests ruby internal code, bug 643922
	sed -e '/test_encrypted_roundtrip/,/^  end/ s:^:#:' \
		-e '/test_missing_environment/,/^  end/ s:^:#:' \
		-e "s:/tmp/:${T}/:" \
		-i test/test_netrc.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "gem 'minitest', '~> 5.0'; Dir['test/test_*.rb'].each{|f| require f}" || die
}
