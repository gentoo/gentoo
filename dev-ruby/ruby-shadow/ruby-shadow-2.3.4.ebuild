# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-shadow/ruby-shadow-2.3.4.ebuild,v 1.7 2014/12/22 13:46:11 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="HISTORY README README.euc"

inherit multilib ruby-fakegem

DESCRIPTION="ruby shadow bindings"
HOMEPAGE="https://github.com/apalmblad/ruby-shadow http://ttsky.net"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

each_ruby_configure() {
	${RUBY} extconf.rb || die "Configuration failed."
	sed -i -e "/^ldflags  =/s/$/ \$(LDFLAGS)/" Makefile || die
}

each_ruby_compile() {
	emake V=1
	mkdir -p lib
	cp shadow$(get_modname) lib/ || die
}
