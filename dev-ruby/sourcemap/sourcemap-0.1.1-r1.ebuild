# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby source maps"
HOMEPAGE="https://github.com/maccman/sourcemap"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e 's/MiniTest/Minitest/' test/test_*.rb || die
}
