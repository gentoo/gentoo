# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="irb.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Interactive Ruby command-line tool for REPL (Read Eval Print Loop)"
HOMEPAGE="https://github.com/ruby/irb"
SRC_URI="https://github.com/ruby/irb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

# Ensure a new enough eselect-ruby is present to avoid clobbering the
# irb bin and man page.
ruby_add_rdepend "
	>=dev-ruby/rdoc-4.0.0
	>=dev-ruby/reline-0.4.2
	!<app-eselect/eselect-ruby-20231008
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/debug
		dev-ruby/test-unit
		dev-ruby/test-unit-ruby-core
	)"

all_ruby_prepare() {
	sed -e 's:_relative ":"./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Skip test requiring specific character set
	sed -e '/test_raise_exception_with_different_encoding_containing_invalid_byte_sequence/aomit "charset"' \
		-i test/irb/test_raise_exception.rb || die

	# Skip tests that require the unpackaged tracer gem
	sed -e '/test_use_tracer_enabled_when_gem_is_available/aomit "Requires tracer gem"' \
		-i test/irb/test_tracer.rb || die

	# Skip tests confused by our test path
	sed -e '/test_backtrace_filtering/aomit "Fails due to unexpected paths"' \
		-i test/irb/test_irb.rb || die
}

each_ruby_test() {
	RUBYLIB=lib ${RUBY} -S rake test || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/irb.1
}
