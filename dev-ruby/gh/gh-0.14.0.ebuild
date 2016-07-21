# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="multi-layer client for the github api v3"
HOMEPAGE="http://gh.rkh.im/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/webmock
"

ruby_add_rdepend "
	dev-ruby/addressable
	dev-ruby/backports
	>dev-ruby/faraday-0.8
	>dev-ruby/multi_json-1.0
	>=dev-ruby/net-http-persistent-2.7
	dev-ruby/net-http-pipeline
"
