# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

inherit unpacker

DESCRIPTION="Library needed to connect puppet to puppetdb"
HOMEPAGE="http://docs.puppetlabs.com/puppetdb/"
SRC_URI="http://apt.puppetlabs.com/pool/wheezy/PC1/${PN:0:1}/puppetdb/${PN}_${PV}-1puppetlabs1_all.deb"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
# will need the same keywords as puppet
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND+=""
DEPEND+=""

S=${WORKDIR}

src_install() {
	insinto opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/
	doins -r opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/*
}
