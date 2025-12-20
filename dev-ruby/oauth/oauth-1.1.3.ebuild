# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md TODO"

RUBY_FAKEGEM_GEMSPEC="oauth.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="https://github.com/ruby-oauth/oauth"
SRC_URI="https://github.com/ruby-oauth/oauth/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="test"

ruby_add_rdepend "
	|| ( dev-ruby/base64:0.3 dev-ruby/base64:0.2 )
	>=dev-ruby/oauth-tty-1.0.6:1
	dev-ruby/snaky_hash:1
	>=dev-ruby/version_gem-1.1.9:1
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/webmock
	dev-ruby/rack
	dev-ruby/rest-client
	|| ( dev-ruby/actionpack:7.2 dev-ruby/actionpack:7.1 )
	|| ( dev-ruby/railties:7.2 dev-ruby/railties:7.1 )
)"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/kettle/I s:^:#:' \
		-i spec/spec_helper.rb || die

	rm -f spec/oauth/request_proxy/curb_spec.rb || die
}
