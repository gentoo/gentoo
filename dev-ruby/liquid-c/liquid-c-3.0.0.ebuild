# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Liquid performance extension in C"
HOMEPAGE="https://github.com/Shopify/liquid-c"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

MY_PN=${PN/-/_}

ruby_add_rdepend ">=dev-ruby/liquid-3.0.0"

all_ruby_prepare() {
	sed -i -e "s/-Werror//" ext/${MY_PN}/extconf.rb || die
	sed -i -e "/[Bb]undler/d" Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/${MY_PN} extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${MY_PN}
	cp ext/${MY_PN}/${MY_PN}$(get_modname) lib/ || die
}
