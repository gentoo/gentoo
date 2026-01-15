# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Universal Ruby library to handle WebSocket protocol"
HOMEPAGE="https://github.com/imanel/websocket-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/rspec-its
		dev-ruby/webrick
	)
"
