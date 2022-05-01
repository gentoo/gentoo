# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="BUGS README TODO"
RUBY_FAKEGEM_EXTRAINSTALL="metasm metasm.rb misc samples"

inherit ruby-fakegem

DESCRIPTION="Cross-architecture assembler, disassembler, linker, and debugger"
HOMEPAGE="https://metasm.cr0.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="!dev-ruby/metasm:1.0.5
	!dev-ruby/metasm:1.0.4
	!dev-ruby/metasm:1.0.2"
DEPEND="${RDEPEND}"

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
