# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem

DESCRIPTION="Console coloring"
HOMEPAGE="https://github.com/defunkt/colored"
LICENSE="MIT"

KEYWORDS="amd64 ~riscv x86"
SLOT="0"
IUSE=""

each_ruby_prepare() {
	sed -i -e '/[Mm][Gg]/d' Rakefile || die
}
