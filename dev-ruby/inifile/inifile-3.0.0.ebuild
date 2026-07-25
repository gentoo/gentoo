# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

inherit ruby-fakegem

DESCRIPTION="Native Ruby package for reading and writing INI files"
HOMEPAGE="https://github.com/twp/inifile"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${P}-tainted.patch" )

all_ruby_prepare() {
	# Taint has been removed from ruby and not done anything since ruby 2.7
	sed -e '/test_taint/,/^  end/ s:^:#:' \
		-e '/taint/ s:^:#:' \
		-i test/test_inifile.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e "Dir['test/test_*.rb'].each { require _1 }" || die
}
