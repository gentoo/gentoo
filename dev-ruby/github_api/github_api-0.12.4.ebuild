# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Ruby wrapper for the GitHub REST API v3"
HOMEPAGE="https://github.com/peter-murach/github"
SRC_URI="https://github.com/peter-murach/github/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="github-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.3
	>=dev-ruby/descendants_tracker-0.0.4
	>=dev-ruby/faraday-0.8
	<dev-ruby/faraday-0.10
	>=dev-ruby/hashie-3.4
	>=dev-ruby/multi_json-1.7.5
	<dev-ruby/multi_json-2.0
	>=dev-ruby/nokogiri-1.6.6
	dev-ruby/oauth2"

ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.14 dev-ruby/webmock )"
