# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-romkan/ruby-romkan-0.4-r5.ebuild,v 1.7 2015/08/03 12:55:23 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng

DESCRIPTION="A Romaji <-> Kana conversion library for Ruby"
HOMEPAGE="http://0xcc.net/ruby-romkan/"
SRC_URI="http://0xcc.net/ruby-romkan/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DOCS="ChangeLog *.rd"

RUBY_PATCHES=( "${FILESDIR}/${PN}-ruby19.patch" )

each_ruby_test() {
	${RUBY} -I. -Ke test.rb < /dev/null || die "test failed"
}

each_ruby_install() {
	doruby romkan.rb
}

all_ruby_install() {
	dodoc ${DOCS}
}
