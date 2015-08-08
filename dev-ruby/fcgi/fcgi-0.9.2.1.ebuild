# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.rdoc README.signals"

inherit multilib ruby-fakegem

DESCRIPTION="FastCGI library for Ruby"
HOMEPAGE="http://github.com/alphallc/ruby-fcgi-ng"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
LICENSE="Ruby"

DEPEND+=" dev-libs/fcgi"
RDEPEND+=" dev-libs/fcgi"

IUSE=""
SLOT="0"

each_ruby_configure() {
	case ${RUBY} in
		*ruby19|*ruby20)
			${RUBY} -C ext/fcgi extconf.rb || die "extconf failed"
			;;
	esac
}

each_ruby_compile() {
	case ${RUBY} in
		*ruby19|*ruby20)
			emake V=1 -C ext/fcgi
			cp ext/fcgi/fcgi$(get_modname) lib || die
			;;
	esac
}
