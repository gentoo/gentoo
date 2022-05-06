# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md TODO"
RUBY_FAKEGEM_GEMSPEC="httpauth.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library implementing the full HTTP Authentication protocol (RFC 2617)"
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
