# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="multi-layer client for the github api v3"
HOMEPAGE="https://github.com/travis-ci/gh"
SRC_URI="https://github.com/travis-ci/gh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/webmock
"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.4.0 =dev-ruby/addressable-2.4*
	dev-ruby/backports
	>dev-ruby/faraday-0.8
	>dev-ruby/multi_json-1.0
	>=dev-ruby/net-http-persistent-2.9:0
	dev-ruby/net-http-pipeline
"
