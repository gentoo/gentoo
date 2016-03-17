# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile TODO"
RUBY_FAKEGEM_EXTRAINSTALL="po"

inherit ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="Ruby/ActiveLDAP provides an activerecord inspired object oriented interface to LDAP"
HOMEPAGE="https://github.com/activeldap/activeldap"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

# Most tests require a live LDAP server to run.
RESTRICT="test"

ruby_add_bdepend "dev-ruby/hoe"

ruby_add_rdepend "
	>=dev-ruby/activemodel-3.2.8:3.2
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
