# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit unpacker

DESCRIPTION="Library needed to connect puppet to puppetdb"
HOMEPAGE="https://puppet.com/docs/puppetdb/latest/index.html"
SRC_URI="http://apt.puppetlabs.com/pool/stretch/puppet/${PN:0:1}/${PN}/${PN}_${PV}-1stretch_all.deb"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
# will need the same keywords as puppet
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

RDEPEND+=""
DEPEND+=""

S=${WORKDIR}

src_install() {
	insinto opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/
	doins -r opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/*
}
