# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/digest/extconf.rb ext/digest/bubblebabble/extconf.rb ext/digest/md5/extconf.rb ext/digest/rmd160/extconf.rb ext/digest/sha1/extconf.rb ext/digest/sha2/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="digest.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides a framework for message digest libraries"
HOMEPAGE="https://github.com/ruby/digest"
SRC_URI="https://github.com/ruby/digest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:ext/digest/lib:.:test:test/lib -rhelper -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
