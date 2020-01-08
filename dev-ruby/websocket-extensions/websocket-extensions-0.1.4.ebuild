# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Generic extension manager for WebSocket connections"
HOMEPAGE="https://github.com/faye/websocket-extensions-ruby"
SRC_URI="https://github.com/faye/websocket-extensions-ruby/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""
