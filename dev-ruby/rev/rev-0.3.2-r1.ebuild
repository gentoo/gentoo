# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# ruby22 -> does not compile
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.textile"

RUBY_FAKEGEM_TASK_TEST=""

inherit multilib ruby-fakegem

DESCRIPTION="Rev is an event library for Ruby, built on the libev event library"
HOMEPAGE="https://rubygems.org/gems/rev"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/iobuffer-0.1.0"

each_ruby_configure() {
	${RUBY} -C ext/rev extconf.rb || die "Unable to configure rev extionsion."

	${RUBY} -C ext/http11_client extconf.rb || die "Unable to configure http11 extension."
}

each_ruby_compile() {
	# We have injected --no-undefined in Ruby as a safety precaution
	# against broken ebuilds, but these bindings unfortunately rely on
	# the lazy load of other extensions; see bug #320545.
	find ext/rev -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined::' || die "--no-undefined removal failed"
	emake -C ext/rev V=1 || die "Unable to compile rev extension."

	emake -C ext/http11_client V=1 || die "Unable to compile http11 extension."
}

each_ruby_install() {
	cp ext/rev/rev_ext$(get_modname) lib || die
	cp ext/http11_client/http11_client$(get_modname) lib || die

	each_fakegem_install
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/examples
	doins examples/* || die "Unable to install examples."
}
