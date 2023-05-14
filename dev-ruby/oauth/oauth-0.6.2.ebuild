# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP="oauth"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md TODO"

RUBY_FAKEGEM_GEMSPEC="oauth.gemspec"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="https://github.com/oauth-xx/oauth-ruby"
SRC_URI="https://github.com/oauth-xx/oauth-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/snaky_hash:1
	>=dev-ruby/version_gem-1.1:1
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/test-unit:2
	dev-ruby/mocha:1.0
	dev-ruby/webmock
	dev-ruby/rack
	dev-ruby/actionpack:6.1
	dev-ruby/railties:6.1
)"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Require a compatible version of mocha
	sed -i -e '1igem "mocha", "~> 1.0"; gem "railties", "~>6.1.0" ; gem "actionpack", "~>6.1.0"; require "action_dispatch"' \
		-e '/mocha/ s/mini_test/minitest/' \
		-e 's/if RUN_COVERAGE/if false/' test/test_helper.rb || die

	# Avoid test tripped up by kwargs confusion
	sed -i -e '/test_authorize/askip "kwargs confusion"' test/units/cli_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/*test*.rb"].each {|f| require f}' || die
}
