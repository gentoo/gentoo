# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A library to help write robots.txt compliant web robots"
HOMEPAGE="https://github.com/knu/webrobots"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.4"

ruby_add_bdepend "test? ( dev-ruby/shoulda dev-ruby/test-unit:2 dev-ruby/webmock )"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/d' Rakefile test/helper.rb || die

	# Avoid tests for live websites requirering a network connection.
	sed -i -e '/robots.txt in the real world/,/^  end/ s:^:#:' test/test_webrobots.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}
