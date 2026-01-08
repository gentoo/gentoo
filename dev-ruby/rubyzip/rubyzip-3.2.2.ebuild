# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="rubyzip.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A ruby library for reading and writing zip files"
HOMEPAGE="https://github.com/rubyzip/rubyzip"
# Tests are not included in the gem.
SRC_URI="https://github.com/rubyzip/rubyzip/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Ruby-BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

DEPEND="test? ( app-arch/zip )"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}

all_ruby_prepare() {
	# Avoid dependencies on simplecov and coveralls
	sed -e '/simplecov/ s:^:#:' \
		-e '1igem "minitest", "~> 5.0"' \
		-i test/test_helper.rb || die

	# Avoid dependency on bundler
	sed -e '/\bundler/ s:^:#: ; /rubocop/I s:^:#:' \
		-e '2irequire_relative "lib/zip/version"' \
		-e "s:framework = .*:framework = 'gem \"minitest\", \"~> 5.0\"; require \"minitest/autorun\"':" \
		-i Rakefile || die

	# Fix hardcoded path to /tmp
	sed -i -e "s:/tmp/:${T}/:g" test/entry_test.rb || die

	# Add missing requires
	sed -i -e '1irequire "forwardable"; require "pathname"' test/input_stream_test.rb || die
	sed -e '2irequire "zip/version"' \
		-i test/constants_test.rb || die

	# Fix broken test that uses native endian
	sed -i -e '/pack/ s/LLS/VVv/' test/file_extract_test.rb || die

	sed -e "s:_relative ': './:" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
