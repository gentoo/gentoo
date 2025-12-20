# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTRAINSTALL="core schema sig stdlib"
RUBY_FAKEGEM_EXTENSIONS=(ext/rbs_extension/extconf.rb)

RUBY_FAKEGEM_GEMSPEC="rbs.gemspec"

inherit ruby-fakegem

DESCRIPTION="The language for type signatures for Ruby and standard library definitions"
HOMEPAGE="https://github.com/ruby/rbs"
SRC_URI="https://github.com/ruby/rbs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend "dev-ruby/logger"

ruby_add_bdepend "test? ( dev-ruby/bundler <dev-ruby/rdoc-6.12.0 dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# We compile the extension directly
	sed -i -e '/extensiontask/I s:^:#:' Rakefile || die

	# Avoid JSON schema validation tests due to a large dependency stack
	# that would be needed.
	rm -f test/rbs/schema_test.rb || die

	# Avoid setup tests since they require a lot of development dependencies.
	rm -f test/rbs/test/runtime_test_test.rb || die

	# Avoid subtract tests with additonal unpackaged dependencies
	sed -i -e '/def test_subtract/aomit "Skipped due to additional dependencies"' test/rbs/cli_test.rb || die

	# Avoid test that depends on rspec to avoid a huge dependency tree
	# for dev-lang/ruby. This test is automagic but can still cause
	# breakage when rspec is not properly installed, bug 935259
	sed -e '/test_is_double/aomit "Avoid rspec dependency"' -i test/rbs/test/type_check_test.rb || die

	# Avoid tests requiring a network connection
	rm -f test/rbs/collection/installer_test.rb test/rbs/collection/collections_test.rb \
		test/rbs/collection/config_test.rb test/rbs/collection/sources/git_test.rb || die
	sed -i -e '/def test_collection_/aomit "Requires network"' test/rbs/cli_test.rb || die
	sed -i -e '/def test_loading_from_rbs_collection/aomit "Requires network"' test/rbs/environment_loader_test.rb || die

	sed -i -e '/def test_\(method\|paths\)/aomit "Different paths in Gentoo test environment"' test/rbs/cli_test.rb || die
}
