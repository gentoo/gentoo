# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=( ext/prism/extconf.rb )
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/prism"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md docs/*"
RUBY_FAKEGEM_GEMSPEC="prism.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Prism Ruby parser"
HOMEPAGE="https://github.com/ruby/prism"
SRC_URI="https://github.com/ruby/prism/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	# Avoid a dependency on rake-compiler
	sed -e '/PRISM_FFI_BACKEND/ s/$/ and false/' \
		-i Rakefile || die

	# Avoid a test that won't work reliably in our varied build environments.
	sed -e '/test_prism_so_exports_only_the_C_extension_init_function/aomit "Not reliable on Gentoo."' \
		-i test/prism/library_symbols_test.rb || die
}

each_ruby_prepare() {
	# rake imports all rakelib/* (bug #947054)
	rm rakelib/rdoc.rake || die
	${RUBY} -S rake templates || die
}
