# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby gem that implements the MQTT protocol"
HOMEPAGE="https://github.com/njh/ruby-mqtt"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
