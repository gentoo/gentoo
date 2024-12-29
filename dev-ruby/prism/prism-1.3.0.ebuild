# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	# Avoid a dependency on rake-compiler
	sed -e '/PRISM_FFI_BACKEND/ s/$/ and false/' \
		-i Rakefile || die
}

each_ruby_prepare() {
	${RUBY} -S rake templates || die
}
