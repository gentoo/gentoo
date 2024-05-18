# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md doc/reline/face.md"
RUBY_FAKEGEM_GEMSPEC="reline.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Alternative readline implementation in pure Ruby"
HOMEPAGE="https://github.com/ruby/reline"
SRC_URI="https://github.com/ruby/reline/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_rdepend ">=dev-ruby/io-console-0.5.0:0"

all_ruby_prepare() {
	sed -e "s:_relative ':'./:" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test/reline -rhelper -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
