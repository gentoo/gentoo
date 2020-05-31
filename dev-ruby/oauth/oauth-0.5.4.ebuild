# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="HISTORY README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="https://github.com/oauth-xx/oauth-ruby"
SRC_URI="https://github.com/oauth-xx/oauth-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-macos"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/test-unit:2
	dev-ruby/mocha:1.0
	dev-ruby/webmock
	dev-ruby/rack
	dev-ruby/actionpack:5.2
	dev-ruby/railties:5.2
)"

all_ruby_prepare() {
	# Require a compatible version of mocha
	sed -i -e '1igem "mocha", "~> 1.0"; gem "railties", "~>5.2.0" ; gem "actionpack", "~>5.2.0"' \
		-e '2i gem "test-unit"; require "test/unit"' \
		-e '/mocha/ s/mini_test/minitest/' \
		-e '/\(byebug\|minitest_helpers\|simplecov\)/I s:^:#:' test/test_helper.rb || die
}
