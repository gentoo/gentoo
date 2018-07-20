# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="Approximate Matching Extension for Ruby"
HOMEPAGE="https://flori.github.com/amatch/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/tins-1*"

# These packages also provide agrep, bug 626480
RDEPEND+=" !app-misc/glimpse !app-text/agrep !dev-libs/tre"

all_ruby_prepare() {
	# mize is listed as a dependency but not actually used
	sed -i -e '/mize/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext V=1
	cp ext/amatch_ext$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb-2 tests/* || die
}
