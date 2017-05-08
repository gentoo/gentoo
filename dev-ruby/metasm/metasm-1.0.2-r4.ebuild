# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="BUGS README TODO"
RUBY_FAKEGEM_EXTRAINSTALL="metasm metasm.rb misc samples"

inherit ruby-fakegem

DESCRIPTION="cross-architecture assembler, disassembler, linker, and debugger"
HOMEPAGE="http://metasm.cr0.org/"

LICENSE="LGPL-2.1"
SLOT="${PV}"
IUSE=""

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jjyg/metasm.git"
	KEYWORDS=""
	SRC_URI=""
	EGIT_CHECKOUT_DIR="${WORKDIR}/all"
else
	KEYWORDS="~amd64 ~arm ~x86"
fi

QA_PREBUILT="usr/lib*/ruby/gems/*/gems/${P}/${PN}/dynldr-linux-x64-233.so"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	if [ -f Gemfile.lock ]; then
		rm  Gemfile.lock || die
	fi

	mkdir bin
	ln -s ../samples/disassemble.rb ./bin/disassemble
}

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper disassemble
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['tests/*.rb'].each{|f| require f}" || die
}
