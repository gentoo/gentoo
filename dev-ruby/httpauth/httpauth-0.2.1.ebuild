# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/httpauth/httpauth-0.2.1.ebuild,v 1.4 2015/02/01 15:25:55 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md TODO"

inherit ruby-fakegem

DESCRIPTION="A library supporting the full HTTP Authentication protocol as specified in RFC 2617"
HOMEPAGE="https://github.com/Manfred/HTTPauth"
SRC_URI="https://github.com/Manfred/HTTPauth/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RUBY_S=HTTPauth-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
