# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Power Assert for Minitest"
HOMEPAGE="https://github.com/hsbt/minitest-power_assert"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/minitest:*
	>=dev-ruby/power_assert-1.1
"

all_ruby_prepare() {
	sed -i -e '/bundle/ s:^:#:' Rakefile || die
}
