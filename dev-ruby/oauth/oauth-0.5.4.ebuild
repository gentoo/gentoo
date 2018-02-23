# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="HISTORY README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="https://github.com/oauth-xx/oauth-ruby"
SRC_URI="https://github.com/oauth-xx/oauth-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/test-unit:2
	dev-ruby/mocha:1.0
	dev-ruby/webmock
	dev-ruby/rack
	dev-ruby/actionpack:5.1
)"

all_ruby_prepare() {
	# Require a compatible version of mocha
	sed -i -e '1igem "mocha", "~> 1.0"; gem "actionpack", "~>5.1.0"' \
		-e '2i gem "test-unit"; require "test/unit"' \
		-e '/\(byebug\|minitest_helpers\|simplecov\)/I s:^:#:' test/test_helper.rb || die
}
