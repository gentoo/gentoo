# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="Convenient fixture for testing async components in a reactor"
HOMEPAGE="https://github.com/socketry/sus-fixtures-async"
SRC_URI="https://github.com/socketry/sus-fixtures-async/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	dev-ruby/async
	dev-ruby/sus
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.1-tests-require.patch
)

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Remove the sus configuration which enabled coverage checks.
	# Its dependency is not packaged.
	rm -f config/sus.rb || die
}
