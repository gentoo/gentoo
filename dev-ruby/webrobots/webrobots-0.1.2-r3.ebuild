# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A library to help write robots.txt compliant web robots"
HOMEPAGE="https://github.com/knu/webrobots"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.4"

ruby_add_bdepend "test? ( dev-ruby/shoulda dev-ruby/test-unit:2 dev-ruby/webmock dev-ruby/vcr )"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/d' Rakefile test/helper.rb || die

	# Avoid tests for live websites requirering a network connection.
	sed -i -e '/robots.txt in the real world/,/^  end/ s:^:#:' test/test_webrobots.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}
