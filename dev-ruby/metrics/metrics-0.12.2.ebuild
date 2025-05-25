# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="sus"
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Application metrics and instrumentation."
HOMEPAGE="https://github.com/socketry/metrics"
SRC_URI="https://github.com/socketry/metrics/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/console )"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	sed -e '/covered/I s:^:#:' -i config/sus.rb || die

	# Avoid tests that require unpackaged "bake" and require running
	# with Bundler.
	rm -f test/metrics/backend/capture.rb || die
}
