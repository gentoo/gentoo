# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit multilib ruby-fakegem

DESCRIPTION="a library for serial port (rs232) access in ruby"
HOMEPAGE="http://rubyforge.org/projects/ruby-serialport/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

all_ruby_prepare() {
	# Fix the miniterm script so that it might actually work, we'll
	# install it as example.
	sed -i -e 's:\.\./serialport.so:serialport:' test/miniterm.rb || die
}

each_ruby_configure() {
	cd ext/native || die
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	pushd ext/native &>/dev/null
	emake V=1
	popd &>/dev/null

	# Avoids the need for a specific install phase
	cp ext/native/*$(get_modname) lib/ || die "extension copy failed"
}

all_ruby_install() {
	all_fakegem_install

	# don't compress it
	insinto /usr/share/doc/${PF}/examples
	doins test/miniterm.rb
}
