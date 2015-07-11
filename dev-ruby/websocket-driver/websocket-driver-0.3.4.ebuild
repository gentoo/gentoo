# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/websocket-driver/websocket-driver-0.3.4.ebuild,v 1.2 2015/07/11 07:06:05 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A complete implementation of the WebSocket protocols"
HOMEPAGE="https://github.com/faye/websocket-driver"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/websocket-driver extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/websocket-driver
	cp ext/websocket-driver/websocket_mask.so lib/ || die
}
