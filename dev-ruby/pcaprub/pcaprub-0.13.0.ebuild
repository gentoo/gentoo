# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="FAQ.rdoc README.rdoc USAGE.rdoc"

inherit multilib ruby-fakegem eapi7-ver

DESCRIPTION="Libpcap bindings for ruby compat"
HOMEPAGE="https://rubygems.org/gems/pcaprub"

LICENSE="LGPL-2.1"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND+="net-libs/libpcap"
RDEPEND+="net-libs/libpcap"

# Tests require live access to a network device as root.
RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext/pcaprub_c extconf.rb || die
}

each_ruby_compile() {
	emake -C ext/pcaprub_c V=1
	cp ext/pcaprub_c/pcaprub_c$(get_modname) lib || die
}
