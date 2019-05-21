# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="BUGS README TODO"
RUBY_FAKEGEM_EXTRAINSTALL="metasm metasm.rb misc samples"

inherit ruby-fakegem

DESCRIPTION="cross-architecture assembler, disassembler, linker, and debugger"
HOMEPAGE="https://metasm.cr0.org/"

LICENSE="LGPL-2.1"
SLOT="${PV}"
IUSE=""

KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	mkdir bin
	ln -s ../samples/disassemble.rb ./bin/disassemble
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper disassemble
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['tests/*.rb'].each{|f| require f}" || die
}
