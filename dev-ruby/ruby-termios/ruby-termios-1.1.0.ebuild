# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md termios.rd"

# There are no tests in the gem, and the upstream tests only work
# with a normal TTY, bug 340575.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_BINWRAP=""

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby interface to termios"
HOMEPAGE="http://arika.org/ruby/termios"
LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc x86"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext V=1
	cp ext/termios$(get_modname) lib/ || die
}
