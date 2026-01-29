# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="sus"
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides a separation of concerns interface for IO endpoints"
HOMEPAGE="https://github.com/socketry/io-endpoint"
SRC_URI="https://github.com/socketry/io-endpoint/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/sus-fixtures-async
	dev-ruby/sus-fixtures-openssl
)"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	sed -e '/covered/I s:^:#:' -i config/sus.rb || die

	sed -e "s:/tmp/test.ipc:${TMP}/test.ipc:" \
		-i test/io/endpoint/unix_endpoint.rb || die

	# Avoid tests that require unpackaged "bake" and require running
	# with Bundler.
	rm -f test/traces/backend/capture.rb || die
}
