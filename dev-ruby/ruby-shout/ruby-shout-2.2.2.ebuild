# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby interface to libshout2"
HOMEPAGE="https://github.com/niko/ruby-shout"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND+=" >=media-libs/libshout-2.0"
DEPEND+=" >=media-libs/libshout-2.0"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die "extconf failed"
}

each_ruby_compile() {
	emake -C ext V=1
}

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_newins ext/${PN#ruby-}_ext$(get_modname) lib/${PN#ruby-}_ext$(get_modname)
}
