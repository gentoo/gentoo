# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES README"

inherit ruby-fakegem

DESCRIPTION="LibIDN Ruby Bindings"
HOMEPAGE="https://github.com/deepfryed/idn-ruby"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" net-dns/libidn:0"
DEPEND+=" net-dns/libidn:0"

all_ruby_prepare() {
	# Avoid UTF-8 tests since we cannot guarantee a UTF-8 environment
	rm -f test/tc_Stringprep.rb || die
}

each_ruby_prepare() {
	mkdir lib || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/idn.so lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*.rb"].each{|f| require f}' || die
}
