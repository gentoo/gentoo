# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="TODO doc/text/*"
RUBY_FAKEGEM_EXTRAINSTALL="po"

# Most tests require a running LDAP server
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="ActiveLDAP provides an activerecord inspired object oriented interface to LDAP"
HOMEPAGE="https://github.com/activeldap/activeldap"

LICENSE="GPL-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

ruby_add_rdepend "
	|| ( dev-ruby/activemodel:8.0 dev-ruby/activemodel:7.2 dev-ruby/activemodel:7.1 dev-ruby/activemodel:7.0 )
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
