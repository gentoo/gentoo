# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md TODO"

RUBY_FAKEGEM_GEMSPEC="rubyzip.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A ruby library for reading and writing zip files"
HOMEPAGE="https://github.com/rubyzip/rubyzip"
# Tests are not included in the gem.
SRC_URI="https://github.com/rubyzip/rubyzip/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Ruby-BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND} test? ( app-arch/zip )"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}

all_ruby_prepare() {
	# Avoid dependencies on simplecov and coveralls
	sed -i -e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Avoid dependency on bundler
	sed -i -e '/bundler/ s:^:#: ; /rubocop/I s:^:#:' Rakefile || die

	# Fix hardcoded path to /tmp
	sed -i -e "s:/tmp/:${T}/:g" test/entry_test.rb || die

	# Add missing requires
	sed -i -e '1irequire "forwardable"; require "pathname"' test/input_stream_test.rb || die

	# Fix broken test that uses native endian
	sed -i -e '/pack/ s/LLS/VVv/' test/file_extract_test.rb || die
}
