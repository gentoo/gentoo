# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="BUGS README TODO"
RUBY_FAKEGEM_EXTRAINSTALL="metasm metasm.rb misc samples"

inherit ruby-fakegem

DESCRIPTION="Cross-architecture assembler, disassembler, linker, and debugger"
HOMEPAGE="https://metasm.cr0.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=( "${FILESDIR}/${P}-ruby33.patch" )

all_ruby_prepare() {
	mkdir bin || die
	ln -s ../samples/disassemble.rb ./bin/disassemble || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['tests/*.rb'].each{|f| require f}" || die
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper disassemble
}
