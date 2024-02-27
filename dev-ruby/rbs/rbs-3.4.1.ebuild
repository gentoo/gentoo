# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="test"

ruby_add_rdepend "dev-ruby/abbrev"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/rdoc dev-ruby/test-unit )"

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

	# Avoid tests requiring a network connection
	rm -f test/rbs/collection/installer_test.rb test/rbs/collection/collections_test.rb \
		test/rbs/collection/config_test.rb test/rbs/collection/sources/git_test.rb || die
	sed -i -e '/def test_collection_/aomit "Requires network"' test/rbs/cli_test.rb || die
	sed -i -e '/def test_loading_from_rbs_collection/aomit "Requires network"' test/rbs/environment_loader_test.rb || die

	sed -i -e '/def test_\(method\|paths\)/aomit "Different paths in Gentoo test environment"' test/rbs/cli_test.rb || die
}
