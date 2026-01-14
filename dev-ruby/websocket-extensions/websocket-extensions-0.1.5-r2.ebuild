# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="websocket-extensions.gemspec"

inherit ruby-fakegem

DESCRIPTION="Generic extension manager for WebSocket connections"
HOMEPAGE="https://github.com/faye/websocket-extensions-ruby"
SRC_URI="https://github.com/faye/websocket-extensions-ruby/archive/${PV}.tar.gz -> ${P}-r1.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

PATCHES=( "${FILESDIR}"/${P}-rspec-mocks.patch )
