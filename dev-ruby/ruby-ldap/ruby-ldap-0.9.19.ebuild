# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit multilib ruby-fakegem

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog FAQ NOTES README TODO"

DESCRIPTION="A Ruby interface to some LDAP libraries"
HOMEPAGE="http://ruby-ldap.sourceforge.net/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 ~sparc x86 ~x86-macos"
IUSE="ssl"
DEPEND=">=net-nds/openldap-2
	dev-libs/cyrus-sasl
	ssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

# Current test set is interactive due to certificate generation and requires
# running LDAP daemon
RESTRICT="test"

each_ruby_configure() {
	local myconf="--with-openldap2"
	if ! use ssl ; then
		myconf="${myconf} --without-libcrypto --without-libssl"
	fi
	${RUBY} extconf.rb ${myconf} || die "extconf.rb failed"
	sed -i -e 's:-Wl,--no-undefined::' \
		-e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" Makefile || die
}

each_ruby_compile() {
	emake V=1
	cp ldap$(get_modname) lib/ || die
}
