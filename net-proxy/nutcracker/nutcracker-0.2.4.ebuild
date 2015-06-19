# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/nutcracker/nutcracker-0.2.4.ebuild,v 1.1 2013/10/31 20:04:54 neurogeek Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="A fast, light-weight proxy for Memcached and Redis.
(Twitter's Twemproxy)"
HOMEPAGE="https://github.com/twitter/twemproxy"
SRC_URI="http://twemproxy.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=">=dev-libs/libyaml-0.1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	# Lets use system libyaml
	epatch "${FILESDIR}/${P}-use-system-libyaml.patch"
	eautoreconf
}

src_configure() {
	econf $(use debug) || die "Econf failed"
}

src_install() {
	default_src_install

	insinto /etc/nutcracker
	newins conf/nutcracker.yml nutcracker.yml.example

	newconfd "${FILESDIR}/nutcracker.confd" nutcracker
	newinitd "${FILESDIR}/nutcracker.initd" nutcracker

	if use doc; then
		dodoc -r notes
	fi
}
