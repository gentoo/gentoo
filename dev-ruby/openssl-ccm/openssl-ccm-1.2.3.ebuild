# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem

DESCRIPTION="OpenSSL CBC-MAC (CCM) ruby gem"
HOMEPAGE="https://github.com/SmallLars/openssl-ccm"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/coverall/I s:^:#:' test/test_ccm.rb || die
}
