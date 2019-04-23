# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md TODO HACKING"

inherit ruby-fakegem

DESCRIPTION="Library that implements a subset of the Ruby 1.9 Process::spawn"
HOMEPAGE="https://github.com/rtomayko/posix-spawn/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

LICENSE="MIT LGPL-2.1"
SLOT="0"
IUSE="test"

all_ruby_prepare() {
	eapply "${FILESDIR}/${P}-x86.patch"
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/*$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each {|f| require f}' || die
}
