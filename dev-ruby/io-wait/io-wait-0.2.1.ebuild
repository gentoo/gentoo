# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS="ext/io/wait/extconf.rb"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="io-wait.gemspec"

inherit ruby-fakegem

DESCRIPTION="Waits until IO is readable or writable without blocking"
HOMEPAGE="https://github.com/ruby/io-wait"
SRC_URI="https://github.com/ruby/io-wait/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	sed -e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/task :test/ s:^:#:' -i Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test:test/lib -rhelper -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
