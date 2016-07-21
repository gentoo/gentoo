# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit multilib ruby-fakegem

DESCRIPTION="System Information Gatherer And Reporter"
HOMEPAGE="http://sigar.hyperic.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cbindings/ruby extconf.rb || die
}

each_ruby_compile() {
	emake -Cbindings/ruby V=1
	mkdir lib || die
	cp bindings/ruby/${PN}$(get_modname) lib/ || die
}
