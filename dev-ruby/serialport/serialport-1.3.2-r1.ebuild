# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/native/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="a library for serial port (rs232) access in ruby"
HOMEPAGE="https://github.com/hparra/ruby-serialport/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-clang16-build-fix.patch
)

all_ruby_prepare() {
	# Fix the miniterm script so that it might actually work, we'll
	# install it as example.
	sed -i -e 's:\.\./serialport.so:serialport:' test/miniterm.rb || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc test/miniterm.rb
}
