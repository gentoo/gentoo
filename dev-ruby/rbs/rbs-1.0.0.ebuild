# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTRAINSTALL="core schema sig stdlib"

RUBY_FAKEGEM_GEMSPEC="rbs.gemspec"

inherit ruby-fakegem

DESCRIPTION="The language for type signatures for Ruby and standard library definitions"
HOMEPAGE="https://github.com/ruby/rbs"
SRC_URI="https://github.com/ruby/rbs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/bundler )"

all_ruby_prepare() {
	# Avoid JSON schema validation tests due to a large dependency stack
	# that would be needed.
	rm -f test/rbs/schema_test.rb || die

	sed -i -e '/def test_paths/askip "Different paths in Gentoo test environment"' test/rbs/cli_test.rb || die
}
