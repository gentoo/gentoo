# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"

RUBY_FAKEGEM_GEMSPEC="buftok.gemspec"

inherit ruby-fakegem

DESCRIPTION="Statefully split input data by a specifiable token"
HOMEPAGE="https://github.com/sferik/buftok"
SRC_URI="https://github.com/sferik/buftok/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
