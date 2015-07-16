# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/puppetdb-termini/puppetdb-termini-3.0.1.ebuild,v 1.1 2015/07/16 05:42:41 prometheanfire Exp $

EAPI=5

USE_RUBY="ruby20 ruby21"

inherit ruby-ng multilib

DESCRIPTION="Library needed to connect puppet to puppetdb"
HOMEPAGE="http://docs.puppetlabs.com/puppetdb/"
SRC_URI="https://downloads.puppetlabs.com/puppetdb/puppetdb-${PV}.tar.gz"
RUBY_S="puppetdb-${PV}/puppet/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
# will need the same keywords as puppet
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND+=""
DEPEND+=""

ruby_add_bdepend ">=app-admin/puppet-4.2:="

each_ruby_install() {
	insinto "/usr/$(get_libdir)/ruby/$(ruby_get_version)/puppet/"
	doins -r "${S}"/*
}
