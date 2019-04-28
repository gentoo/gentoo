# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Manages persistent connections using Net::HTTP plus a speed fix for Ruby 1.8"
HOMEPAGE="https://github.com/drbrain/net-http-persistent"

LICENSE="MIT"
SLOT="3"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc test"

ruby_add_rdepend ">=dev-ruby/connection_pool-2.2:0"

ruby_add_bdepend "
	test? ( dev-ruby/hoe dev-ruby/minitest )"

all_ruby_prepare() {
	# avoid test with implicit dependency on net-http-pipeline which
	# fails and is not tested upstream
	sed -i -e '/net-http-pipeline not installed/ s/unless.*$//' test/test_net_http_persistent.rb || die
}
