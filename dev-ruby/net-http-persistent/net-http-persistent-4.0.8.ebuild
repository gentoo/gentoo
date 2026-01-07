# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Manages persistent connections using Net::HTTP plus a speed fix for Ruby 1.8"
HOMEPAGE="https://github.com/drbrain/net-http-persistent"
SRC_URI="https://github.com/drbrain/net-http-persistent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc test"

ruby_add_rdepend "|| ( dev-ruby/connection_pool:3 >=dev-ruby/connection_pool-2.2.4:0 )"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	# Not relevant for us (we're just using rake for the tests)
	sed -i -e '/require "rake\/manifest"/,/^end/ s:^:#:' Rakefile || die

	# avoid test with implicit dependency on net-http-pipeline which
	# fails and is not tested upstream
	sed -i -e '/net-http-pipeline not installed/ s/unless.*$//' test/test_net_http_persistent.rb || die
}
