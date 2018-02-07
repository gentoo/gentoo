# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23"

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
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.4 =dev-ruby/addressable-2.4*
	>=dev-ruby/descendants_tracker-0.0.4 =dev-ruby/descendants_tracker-0.0*
	>=dev-ruby/faraday-0.8:0
	>=dev-ruby/hashie-3.5:3
	=dev-ruby/oauth2-1*"

ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.14 dev-ruby/webmock:2 dev-ruby/vcr:3 )"
