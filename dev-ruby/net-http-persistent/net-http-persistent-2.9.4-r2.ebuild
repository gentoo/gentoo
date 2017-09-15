# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Manages persistent connections using Net::HTTP plus a speed fix for Ruby 1.8"
HOMEPAGE="https://github.com/drbrain/net-http-persistent"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "
	test? ( dev-ruby/hoe dev-ruby/minitest )"

all_ruby_prepare() {
	# due to hoe
	sed -i -e "/license/d" Rakefile || die

	# Avoid unsafe legacy SSL version
	sed -i -e '/ssl_version =/ s/:SSLv3/:TLSv1_2/' test/test_net_http_persistent_ssl_reuse.rb || die
}
