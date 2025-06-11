# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="sus"
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A concurrency framework for Ruby"
HOMEPAGE="https://github.com/socketry/async"
SRC_URI="https://github.com/socketry/async/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

ruby_add_rdepend "
	>=dev-ruby/console-1.29:1
	dev-ruby/fiber-annotation
	>=dev-ruby/io-event-1.9:1
	>=dev-ruby/metrics-0.12:0
	>=dev-ruby/traces-0.15:0
"

ruby_add_bdepend "test? (
	dev-ruby/benchmark-ips
	dev-ruby/sus-fixtures-async
	dev-ruby/sus-fixtures-console
	dev-ruby/sus-fixtures-time
)"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# network tests
	rm test/net/http.rb \
		test/async/scheduler/address.rb \
		test/async/scheduler/io.rb || die

	# Remove developer-only test configuration
	rm -f config/sus.rb || die
}
