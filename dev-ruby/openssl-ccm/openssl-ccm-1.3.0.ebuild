# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="openssl-ccm.gemspec"

inherit ruby-fakegem

DESCRIPTION="OpenSSL CBC-MAC (CCM) ruby gem"
HOMEPAGE="https://github.com/SmallLars/openssl-ccm"
SRC_URI="https://github.com/SmallLars/openssl-ccm/archive/refs/tags/${PV}.tar.gz -> {P}.tar.gz"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/coverall/I s:^:#:' test/test_ccm.rb || die
}
