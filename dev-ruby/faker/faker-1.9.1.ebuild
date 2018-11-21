# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="A library for generating fake data such as names, addresses, and phone numbers"
HOMEPAGE="https://github.com/stympy/faker"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/i18n-0.7:*"
