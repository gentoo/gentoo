# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="TODO.md README.md"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/debug/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/debug"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Debugging functionality for Ruby"
HOMEPAGE="https://github.com/ruby/debug"
SRC_URI="https://github.com/ruby/debug/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

# Avoid tests for now since the results in a very deep dependency list for ruby32
#ruby_add_depend "test? ( dev-ruby/rr )"
RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/irb-1.10:0
	>=dev-ruby/reline-0.3.8
"

all_ruby_prepare() {
	sed -e "s:require_relative ':require './:" \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}
