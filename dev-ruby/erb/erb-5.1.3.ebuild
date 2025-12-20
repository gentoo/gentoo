# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

# There is an erb binary in exe but that would conflict with the ruby
# built-in version.
RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_EXTENSIONS=(ext/erb/escape/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/erb"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="libexec"
RUBY_FAKEGEM_GEMSPEC="erb.gemspec"

inherit ruby-fakegem

DESCRIPTION="An easy to use but powerful templating system for Ruby"
HOMEPAGE="https://github.com/ruby/erb"
SRC_URI="https://github.com/ruby/erb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -rtest/lib/helper -e "Dir['test/**/test_*.rb'].each { require _1 }" || die
}
