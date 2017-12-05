# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

inherit unpacker

DESCRIPTION="Library needed to connect puppet to puppetdb"
HOMEPAGE="http://docs.puppetlabs.com/puppetdb/"
SRC_URI="http://apt.puppetlabs.com/pool/xenial/puppet5/${PN:0:1}/${PN}/${PN}_${PV}-1xenial_all.deb"

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
