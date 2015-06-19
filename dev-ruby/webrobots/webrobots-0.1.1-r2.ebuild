# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/webrobots/webrobots-0.1.1-r2.ebuild,v 1.2 2015/04/12 07:23:03 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A library to help write robots.txt compliant web robots"
HOMEPAGE="http://rubygems.org/gems/webrobots"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.4"

ruby_add_bdepend "test? ( dev-ruby/shoulda dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/d' Rakefile test/helper.rb || die

	# Avoid tests for live websites requirering a network connection.
	sed -i -e '/robots.txt in the real world/,/^  end/ s:^:#:' test/test_webrobots.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}
