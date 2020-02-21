# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="A fast, light-weight proxy for Memcached and Redis.
(Twitter's Twemproxy)"
HOMEPAGE="https://github.com/twitter/twemproxy"
SRC_URI="https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=">=dev-libs/libyaml-0.1.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/twemproxy-${PV}"

src_prepare() {
	# Lets use system libyaml
	epatch "${FILESDIR}/${PN}-0.3.0-use-system-libyaml.patch"
	eautoreconf
}

src_configure() {
	econf $(use debug)
}

src_install() {
	default_src_install

	insinto /etc/nutcracker
	newins conf/nutcracker.yml nutcracker.yml.example

	newconfd "${FILESDIR}/nutcracker.confd.2" nutcracker
	newinitd "${FILESDIR}/nutcracker.initd.2" nutcracker

	if use doc; then
		dodoc -r notes
	fi
}
