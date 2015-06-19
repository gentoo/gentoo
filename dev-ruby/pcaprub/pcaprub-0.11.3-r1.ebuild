# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pcaprub/pcaprub-0.11.3-r1.ebuild,v 1.3 2015/03/24 16:29:37 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="FAQ.rdoc README.rdoc USAGE.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Libpcap bindings for ruby compat"
HOMEPAGE="https://rubygems.org/gems/pcaprub"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND+="net-libs/libpcap"
RDEPEND+="net-libs/libpcap"

# Tests require live access to a network device as root.
RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake -C ext/${PN} V=1
	cp ext/${PN}/${PN}$(get_modname) lib || die
}
