# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="prime.gemspec"

inherit ruby-fakegem

DESCRIPTION="Prime numbers and factorization library"
HOMEPAGE="https://github.com/ruby/prime"
SRC_URI="https://github.com/ruby/prime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

ruby_add_rdepend "
	dev-ruby/forwardable
	dev-ruby/singleton
"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test:test/lib -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
