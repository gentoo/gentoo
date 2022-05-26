# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-ng

DESCRIPTION="RFC 2229 client in Ruby"
HOMEPAGE="http://www.caliban.org/ruby/ruby-dict.shtml"
SRC_URI="http://www.caliban.org/files/ruby/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

all_ruby_prepare() {
	eapply -p0 "${FILESDIR}/${PN}-ruby19.patch"

	default
}

each_ruby_install() {
	doruby lib/dict.rb || die "doruby failed"
}

all_ruby_install() {
	dobin rdict

	dodoc README Changelog TODO doc/rfc2229.txt
	dodoc doc/dict.html doc/rdict.html

	# This would probably need a 3rb section..
	# doman doc/dict.3
	doman doc/rdict.1
}
