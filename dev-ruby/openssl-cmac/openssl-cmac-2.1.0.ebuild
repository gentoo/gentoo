# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="openssl-cmac.gemspec"

inherit ruby-fakegem

DESCRIPTION="Gem for RFC 4493, 4494, 4615 - The AES-CMAC Algorithm"
HOMEPAGE="https://github.com/SmallLars/openssl-cmac"
SRC_URI="https://github.com/SmallLars/openssl-cmac/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/coverall/I s:^:#:' test/test_cmac.rb || die
}
