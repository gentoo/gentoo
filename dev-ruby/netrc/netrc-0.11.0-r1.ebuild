# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="changelog.txt Readme.md"

inherit ruby-fakegem

DESCRIPTION="This library reads and writes .netrc files"
HOMEPAGE="https://github.com/geemus/netrc"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	# Avoid broken test that wrongly tests ruby internal code, bug 643922
	sed -e '/test_encrypted_roundtrip/,/^  end/ s:^:#:' \
		-e '/test_missing_environment/,/^  end/ s:^:#:' \
		-e "s:/tmp/:${T}/:" \
		-i test/test_netrc.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
