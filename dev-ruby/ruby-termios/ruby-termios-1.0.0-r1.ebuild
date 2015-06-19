# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-termios/ruby-termios-1.0.0-r1.ebuild,v 1.1 2015/06/03 05:53:50 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit multilib ruby-ng

DESCRIPTION="A Ruby interface to termios"
HOMEPAGE="http://arika.org/ruby/termios"
SRC_URI="https://github.com/arika/ruby-termios/archive/version_${PV//./_}.tar.gz -> ${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86 ~x86-macos"
IUSE=""

RUBY_S="${PN}-version_${PV//./_}"

# Tests require a normal TTY, bug 340575. They should all pass when run
# manually.
RESTRICT=test

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext V=1
	cp ext/termios$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test0.rb || die "tests failed"
}

each_ruby_install() {
	emake V=1 -Cext DESTDIR="${D}" install
}

all_ruby_install() {
	dodoc ChangeLog README termios.rd

	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
