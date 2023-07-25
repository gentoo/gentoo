# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Universal Ruby library to handle WebSocket protocol"
HOMEPAGE="https://github.com/imanel/websocket-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/rspec-its
		dev-ruby/webrick
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-default-port.patch
)
