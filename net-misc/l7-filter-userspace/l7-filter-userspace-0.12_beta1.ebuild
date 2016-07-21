# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils versionator

MY_P=${PN}-$(replace_version_separator 2 '-')

DESCRIPTION="Userspace utilities for layer 7 iptables QoS"
HOMEPAGE="http://l7-filter.clearfoundation.com/"
SRC_URI="http://download.clearfoundation.com/l7-filter/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SLOT="0"

DEPEND=">=net-libs/libnetfilter_conntrack-0.0.100
	>=net-libs/libnetfilter_queue-1.0.0
	net-libs/libnfnetlink"
RDEPEND="${DEPEND}
	net-misc/l7-protocols"

S=${WORKDIR}/${MY_P}

DOCS=( README TODO BUGS THANKS AUTHORS )

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.11-libnetfilter_conntrack-0.0.100.patch" \
		"${FILESDIR}/${PN}-0.11-datatype.patch"
}
