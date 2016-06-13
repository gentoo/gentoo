# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CONTRIBUTING.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby toolkit for the Github API"
HOMEPAGE="https://github.com//octokit/octokit.rb"
SRC_URI="https://github.com/octokit/octokit.rb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RUBY_S=octokit.rb-${PV}

ruby_add_rdepend ">=dev-ruby/sawyer-0.5.3"
ruby_add_bdepend "test? ( >=dev-ruby/netrc-0.7.7
	dev-ruby/vcr:2
	>=dev-ruby/webmock-1.9 )"

all_ruby_prepare() {
	sed -i -e "1,10d" -e "/require 'vcr'/i\gem 'vcr', '~> 2.9.2'" spec/helper.rb || die
}
