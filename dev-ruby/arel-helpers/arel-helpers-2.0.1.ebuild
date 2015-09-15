# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "|| ( dev-ruby/activerecord:3.2
			dev-ruby/activerecord:4.0
			dev-ruby/activerecord:4.1
			dev-ruby/activerecord:4.2 )"
