# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="history.md README.rdoc"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Simple Simple HTTP and REST client for Ruby"
HOMEPAGE="https://github.com/archiloque/rest-client"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/webmock )"

ruby_add_rdepend "
	>=dev-ruby/http-cookie-1.0.2:0
	>=dev-ruby/mime-types-1.16
	>=dev-ruby/netrc-0.7:0"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' \
		-e '/namespace :windows/,/^end/ s:^:#:' -i Rakefile || die

	# Remove spec that requires network access.
	rm spec/integration/request_spec.rb || die
}
