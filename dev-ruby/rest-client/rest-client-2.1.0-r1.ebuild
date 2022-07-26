# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="history.md README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Simple HTTP and REST client for Ruby"
HOMEPAGE="https://github.com/rest-client/rest-client"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/webmock:3 )"

ruby_add_rdepend "
	>=dev-ruby/http-accept-1.7.0:1
	>=dev-ruby/http-cookie-1.0.2:0
	>=dev-ruby/mime-types-1.16:* <dev-ruby/mime-types-4:*
	>=dev-ruby/netrc-0.8:0
"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' \
		-e '/namespace :windows/,/^end/ s:^:#:' -i Rakefile || die

	# Remove specs that requires network access.
	rm spec/integration/{httpbin,request}_spec.rb || die

	# Fix specs confused by ruby30 keyword arguments
	sed -i -e 's/with(/with({/' -e '/with/ s/)$/})/' spec/unit/resource_spec.rb || die
	sed -i -e '508 s/1 => 2/{1 => 2}/' spec/unit/request_spec.rb || die
}
