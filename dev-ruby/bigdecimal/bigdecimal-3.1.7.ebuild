# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/bigdecimal/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_GEMSPEC="bigdecimal.gemspec"

inherit ruby-fakegem

DESCRIPTION="Arbitrary-precision decimal floating-point number library for Ruby"
HOMEPAGE="https://github.com/ruby/bigdecimal"
SRC_URI="https://github.com/ruby/bigdecimal/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e '/^source_version/,/^end/ s:^:#:' \
		-e "/s.version/ s/= source_version/= '${PV}'/" \
		-e "/s.name/ s/= name/= 'bigdecimal'/" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -rtest/lib/helper -e "Dir['test/**/test_*.rb'].each { require _1 }" || die
}
