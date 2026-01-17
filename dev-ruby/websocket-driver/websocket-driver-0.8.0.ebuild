# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/websocket-driver/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A complete implementation of the WebSocket protocols"
HOMEPAGE="https://github.com/faye/websocket-driver-ruby"
SRC_URI="https://github.com/faye/websocket-driver-ruby/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="Apache-2.0"
SLOT="0.7"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	dev-ruby/base64
	>=dev-ruby/websocket-extensions-0.1.0
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
}
