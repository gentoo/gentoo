# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="history.md README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Simple HTTP and REST client for Ruby"
HOMEPAGE="https://github.com/archiloque/rest-client"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/webmock:3 )"

ruby_add_rdepend "
	>=dev-ruby/http-cookie-1.0.2:0
	>=dev-ruby/mime-types-1.16:* <dev-ruby/mime-types-4:*
	>=dev-ruby/netrc-0.8:0
	!!<dev-ruby/rest-client-1.8.0-r3:0"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' \
		-e '/namespace :windows/,/^end/ s:^:#:' -i Rakefile || die

	# Remove specs that requires network access.
	rm spec/integration/{httpbin,request}_spec.rb || die
}
