# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activeldap/activeldap-4.0.4.ebuild,v 1.1 2015/01/04 09:50:53 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile TODO doc/text/*"
RUBY_FAKEGEM_EXTRAINSTALL="po"

inherit ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="Ruby/ActiveLDAP provides an activerecord inspired object oriented interface to LDAP"
HOMEPAGE="https://github.com/activeldap/activeldap"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

# Most tests require a live LDAP server to run.
RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/activemodel-4.0.0:4.0
	dev-ruby/locale
	dev-ruby/ruby-gettext
	dev-ruby/gettext_i18n_rails
	|| ( >=dev-ruby/ruby-ldap-0.8.2 dev-ruby/ruby-net-ldap )"

all_ruby_install() {
	all_fakegem_install

	dodoc doc/text/*

	insinto /usr/share/doc/${PF}
	doins -r examples
}
