# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="getoptlong.gemspec"

inherit ruby-fakegem

DESCRIPTION="Allows you to parse command line options similarly to getopt_long()"
HOMEPAGE="https://github.com/ruby/getoptlong"
SRC_URI="https://github.com/ruby/getoptlong/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	sed -e 's/__FILE__/"getoptlong.gemspec"/' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test:test/lib -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
