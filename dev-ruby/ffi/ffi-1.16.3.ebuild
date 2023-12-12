# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="ffi.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/ffi_c/extconf.rb)

inherit ruby-fakegem toolchain-funcs

DESCRIPTION="Ruby extension for programmatically loading dynamic libraries"
HOMEPAGE="https://github.com/ffi/ffi/wiki"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Needs recent libffi for HPPA fixes (and probably Apple arm64 too)
RDEPEND+=" >=dev-libs/libffi-3.4.4-r1:="
DEPEND+=" >=dev-libs/libffi-3.4.4-r1:="

ruby_add_bdepend "dev-ruby/rake"

all_ruby_prepare() {
	sed -i -e '/tasks/ s:^:#:' \
		-e '/Gem::Tasks/,/end/ s:^:#:' Rakefile || die

	sed -e '/require/c\require "./lib/ffi/version"' \
		-e 's/git ls-files -z/find * -print0/' \
		-e '/^  lfs/,/^  end/ s:^:#:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Fix Makefile for tests
	sed -i -e '/CCACHE :=/ s:^:#:' \
		-e 's/-O2//' \
		-e 's/^CFLAGS =/CFLAGS +=/' spec/ffi/fixtures/GNUmakefile || die

	# Remove bundled version of libffi.
	rm -rf ext/ffi_c/libffi || die
}

each_ruby_compile() {
	each_fakegem_compile

	${RUBY} -S rake -f gen/Rakefile || die "types.conf generation failed"
}

each_ruby_test() {
	CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" ${RUBY} -S rspec spec || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}
