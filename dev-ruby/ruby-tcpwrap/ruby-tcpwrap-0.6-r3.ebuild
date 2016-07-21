# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 -> Does not compile
USE_RUBY="ruby20 ruby21"

inherit ruby-ng

DESCRIPTION="A TCP wrappers library for Ruby"
HOMEPAGE="http://raa.ruby-lang.org/list.rhtml?name=ruby-tcpwrap"
SRC_URI="http://shugo.net/archive/ruby-tcpwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc x86"
IUSE=""

DEPEND+=" net-libs/libident
	sys-apps/tcp-wrappers"

RDEPEND+=" net-libs/libident
	sys-apps/tcp-wrappers"

RUBY_S="${PN}"
RUBY_PATCHES=( "${P}-ruby19.patch" )

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	# We have injected --no-undefined in Ruby as a safety precaution
	# against broken ebuilds, but the Ruby-Gnome bindings
	# unfortunately rely on the lazy load of other extensions; see bug
	# #320545.
	find . -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined ::' || die "--no-undefined removal failed"

	emake V=1
}

each_ruby_install() {
	emake DESTDIR="${D}" install V=1
}

all_ruby_install() {
	dodoc README*
	dohtml doc/*

	docinto sample
	dodoc sample/*
}
