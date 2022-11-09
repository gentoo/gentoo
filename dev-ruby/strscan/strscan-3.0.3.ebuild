# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="strscan.gemspec"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_EXTENSIONS=(ext/strscan/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Provides lexical scanning operations on a String"
HOMEPAGE="https://github.com/ruby/strscan"
SRC_URI="https://github.com/ruby/strscan/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="$(ver_cut 1)"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test/lib -rhelper run-test.rb || die
}
