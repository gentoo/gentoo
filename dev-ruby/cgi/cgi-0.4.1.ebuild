# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTENSIONS=(ext/cgi/escape/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/cgi
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="cgi.gemspec"

inherit ruby-fakegem

DESCRIPTION="Support for the Common Gateway Interface protocol"
HOMEPAGE="https://github.com/ruby/cgi"
SRC_URI="https://github.com/ruby/cgi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e "/spec.version/ s/= version/= '${PV}'/" \
		-e "/spec.name/ s/= name/= '${PN}'/" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -rtest/lib/helper -e "Dir['test/**/test_*.rb'].each { require _1 }" || die
}
