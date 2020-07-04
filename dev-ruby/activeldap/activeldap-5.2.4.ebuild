# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile TODO doc/text/*"
RUBY_FAKEGEM_EXTRAINSTALL="po"

inherit ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="ActiveLDAP provides an activerecord inspired object oriented interface to LDAP"
HOMEPAGE="https://github.com/activeldap/activeldap"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

# Most tests require a live LDAP server to run.
RESTRICT="test"

ruby_add_rdepend "
	>dev-ruby/activemodel-4.2.0:*
	dev-ruby/builder
	dev-ruby/locale
	dev-ruby/ruby-gettext
	dev-ruby/gettext_i18n_rails
	|| ( dev-ruby/ruby-net-ldap >=dev-ruby/ruby-ldap-0.8.2 )"

all_ruby_install() {
	all_fakegem_install

	dodoc doc/text/*
	dodoc -r examples
}
