# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Power Assert for Minitest"
HOMEPAGE="https://github.com/hsbt/minitest-power_assert"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/minitest:*
	>=dev-ruby/power_assert-1.1
"

all_ruby_prepare() {
	sed -i -e '/bundle/ s:^:#:' Rakefile || die
}
