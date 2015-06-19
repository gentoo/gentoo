# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-shout/ruby-shout-2.2.1.ebuild,v 1.3 2014/04/24 16:54:01 mrueg Exp $

EAPI=5

USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit multilib ruby-fakegem eutils

DESCRIPTION="A Ruby interface to libshout2"
HOMEPAGE="http://ruby-shout.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=media-libs/libshout-2.0"
DEPEND="${DEPEND}
	>=media-libs/libshout-2.0"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die "extconf failed"
}

each_ruby_compile() {
	emake -C ext || die "emake failed"
}

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_newins ext/${PN#ruby-}_ext$(get_modname) lib/${PN#ruby-}_ext$(get_modname)
}
