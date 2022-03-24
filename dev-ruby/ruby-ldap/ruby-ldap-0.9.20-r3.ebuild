# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-fakegem

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)
RUBY_FAKEGEM_EXTRADOC="ChangeLog FAQ NOTES README TODO"

DESCRIPTION="A Ruby interface to some LDAP libraries"
HOMEPAGE="https://github.com/bearded/ruby-ldap"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl"
DEPEND=">=net-nds/openldap-2:=
	dev-libs/cyrus-sasl
	ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

# Current test set is interactive due to certificate generation and requires
# running LDAP daemon
RESTRICT="test"

each_ruby_configure() {
	local myconf="--with-openldap2"
	if ! use ssl ; then
		myconf="${myconf} --without-libcrypto --without-libssl"
	fi
	RUBY_FAKEGEM_EXTENSION_OPTIONS=${myconf} each_fakegem_configure
}
