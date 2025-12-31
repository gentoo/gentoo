# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-fakegem

DESCRIPTION="Console coloring"
HOMEPAGE="https://github.com/defunkt/colored"
LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

each_ruby_prepare() {
	sed -i -e '/[Mm][Gg]/d' Rakefile || die
}
