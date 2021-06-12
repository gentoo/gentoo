# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

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

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*.rb"].each{|f| require f}' || die
}
