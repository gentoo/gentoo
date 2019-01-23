# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CONTRIBUTING.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby toolkit for the Github API"
HOMEPAGE="https://github.com/octokit/octokit.rb"
SRC_URI="https://github.com/octokit/octokit.rb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RUBY_S=octokit.rb-${PV}

ruby_add_rdepend ">=dev-ruby/sawyer-0.8.0"
ruby_add_bdepend "test? ( dev-ruby/mime-types
	>=dev-ruby/netrc-0.7.7
	dev-ruby/vcr:3
	dev-ruby/webmock:3 )"

all_ruby_prepare() {
	sed -i -e '/if RUBY_ENGINE/,/^end/ s:^:#: ; 1igem "webmock", "~>3.0"' spec/helper.rb || die
}
