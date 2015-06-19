# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/posix-spawn/posix-spawn-0.3.9.ebuild,v 1.2 2015/01/30 07:06:00 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"
KEYWORDS="~amd64"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md TODO HACKING"

inherit ruby-fakegem

DESCRIPTION="The posix-spawn library aims to implement a subset of the Ruby 1.9 Process::spawn"
HOMEPAGE="https://github.com/rtomayko/posix-spawn/"

LICENSE="MIT LGPL-2.1"
SLOT="0"
IUSE="test"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/*$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test || die
}
