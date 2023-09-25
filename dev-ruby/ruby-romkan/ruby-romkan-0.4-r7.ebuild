# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

inherit ruby-ng

DESCRIPTION="A Romaji <-> Kana conversion library for Ruby"
HOMEPAGE="http://0xcc.net/ruby-romkan/"
SRC_URI="http://0xcc.net/ruby-romkan/${P}.tar.gz"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DOCS="ChangeLog *.rd"

all_ruby_prepare() {
	eapply -p0 "${FILESDIR}/${PN}-ruby19.patch"
}

each_ruby_test() {
	${RUBY} -I. -Ke test.rb < /dev/null || die "test failed"
}

each_ruby_install() {
	doruby romkan.rb
}

all_ruby_install() {
	dodoc ${DOCS}
}
