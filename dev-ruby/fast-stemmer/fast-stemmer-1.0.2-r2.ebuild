# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README"

inherit multilib ruby-fakegem

DESCRIPTION="Simple wrapper around multithreaded Porter stemming algorithm"
HOMEPAGE="https://github.com/romanbsd/fast-stemmer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	rm ext/Makefile || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/stemmer$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb-2 test/fast_stemmer_test.rb || die
}
