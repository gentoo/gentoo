# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTENSIONS=(ext/io/console/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/io"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="io-console.gemspec"

inherit ruby-fakegem

DESCRIPTION="add console capabilities to IO instances"
HOMEPAGE="https://github.com/ruby/io-console"
SRC_URI="https://github.com/ruby/io-console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

all_ruby_prepare() {
	sed -e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/task :test/ s:^:#:' -i Rakefile || die

	# Avoid test that require a proper TTY
	sed -e '/test_\(bad_keyword\|failed_path\)/aomit "requires TTY"' \
		-i test/io/console/test_io_console.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test:test/lib -rhelper -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
