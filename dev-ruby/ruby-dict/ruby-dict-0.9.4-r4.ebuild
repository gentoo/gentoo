# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-ng

DESCRIPTION="RFC 2229 client in Ruby"
HOMEPAGE="http://www.caliban.org/ruby/ruby-dict.shtml"
SRC_URI="http://www.caliban.org/files/ruby/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RUBY_PATCHES=( "${PN}-ruby19.patch" )

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
