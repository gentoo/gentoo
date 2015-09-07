# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Pattern recognition for hosts, services, and content"
HOMEPAGE="https://github.com/rapid7/${PN}"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri !=dev-ruby/recog-2.0.0"
