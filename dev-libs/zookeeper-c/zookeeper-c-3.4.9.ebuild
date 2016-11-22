# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="C client interface to Zookeeper server"
HOMEPAGE="https://zookeeper.apache.org/"
SRC_URI="mirror://apache/zookeeper/zookeeper-${PV}/zookeeper-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc static-libs test"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )"

S="${WORKDIR}/zookeeper-${PV}/src/c"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with test cppunit)
}

src_compile() {
	emake
	use doc && emake doxygen-doc
}

src_install() {
	default
	use doc && dohtml docs/html/*
}
