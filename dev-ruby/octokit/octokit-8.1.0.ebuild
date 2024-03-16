# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CONTRIBUTING.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby toolkit for the Github API"
HOMEPAGE="https://github.com/octokit/octokit.rb"
SRC_URI="https://github.com/octokit/octokit.rb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RUBY_S=octokit.rb-${PV}

ruby_add_rdepend "
	|| ( dev-ruby/faraday:2 dev-ruby/faraday:1 )
	>=dev-ruby/sawyer-0.9:0
"

ruby_add_bdepend "test? (
	|| ( ( dev-ruby/faraday:2 dev-ruby/faraday-multipart ) dev-ruby/faraday:1 )
	dev-ruby/jwt
	dev-ruby/mime-types
	>=dev-ruby/netrc-0.7.7
	>=dev-ruby/rbnacl-7.1.1:6
	dev-ruby/vcr[json]
	dev-ruby/webmock:3 )"

all_ruby_prepare() {
	sed -e '/if RUBY_ENGINE/,/^end/ s:^:#: ; 1igem "webmock", "~>3.0"' \
		-e '/pry/ s:^:#:' \
		-i spec/spec_helper.rb || die
}
