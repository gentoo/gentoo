# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Simple wrapper around multithreaded Porter stemming algorithm"
HOMEPAGE="https://github.com/romanbsd/fast-stemmer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

all_ruby_prepare() {
	rm ext/Makefile || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb-2 test/fast_stemmer_test.rb || die
}
