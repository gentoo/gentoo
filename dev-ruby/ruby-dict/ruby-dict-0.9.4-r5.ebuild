# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-ng

DESCRIPTION="RFC 2229 client in Ruby"
HOMEPAGE="https://caliban.org/ruby/ruby-dict.shtml"
SRC_URI="https://caliban.org/files/ruby/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

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
