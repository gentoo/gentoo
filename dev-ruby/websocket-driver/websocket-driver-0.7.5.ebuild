# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

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
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/websocket-extensions-0.1.0"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby31)
			# Avoid specs broken by a cosmetic change in port number handling.
			# https://github.com/faye/websocket-driver-ruby/pull/88
			rm -f spec/websocket/driver/client_spec.rb || die
			;;
	esac
}
