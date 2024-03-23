# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem

DESCRIPTION="Gem for RFC 4493, 4494, 4615 - The AES-CMAC Algorithm"
HOMEPAGE="https://github.com/SmallLars/openssl-cmac"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/coverall/I s:^:#:' test/test_cmac.rb || die
}
