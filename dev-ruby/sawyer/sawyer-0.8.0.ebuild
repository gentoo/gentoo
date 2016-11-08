# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Secret User Agent of HTTP"
HOMEPAGE="https://github.com/lostisland/sawyer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

ruby_add_rdepend "<dev-ruby/faraday-0.10
	>=dev-ruby/addressable-2.3.5 <dev-ruby/addressable-2.6"

all_ruby_prepare() {
	# Avoid tests that require network acces
	sed -i -e '/test_blank_response_doesnt_raise/,/^    end/ s:^:#:' test/agent_test.rb || die
}
