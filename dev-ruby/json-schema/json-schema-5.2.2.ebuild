# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="json-schema.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rake"

inherit ruby-fakegem

DESCRIPTION="Ruby JSON Schema Validator"
HOMEPAGE="https://github.com/voxpupuli/json-schema/"
SRC_URI="https://github.com/voxpupuli/json-schema/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.8
	>=dev-ruby/bigdecimal-3.1
"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

PATCHES=(
	"${FILESDIR}/${P}-remove-dev-tasks.patch"
)

all_ruby_prepare() {
	# The common test suite requires a git submodule (test/test-suite) that
	# is not included in the release tarball. Remove it.
	rm test/common_test_suite_test.rb || die
}
