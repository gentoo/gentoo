# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="resolv.gemspec"

inherit ruby-fakegem

DESCRIPTION="Thread-aware DNS resolver library in Ruby"
HOMEPAGE="https://github.com/ruby/resolv"
SRC_URI="https://github.com/ruby/resolv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# The extension is only compiled on win32
	sed -e '/if RUBY_ENGINE/ s/$/ and false/' \
		-i Rakefile || die
}

each_ruby_install() {
	each_fakegem_install

	# The extension is only compiled on Win32, but we still need to mark
	# that task as done.
	ruby_fakegem_extensions_installed
}
