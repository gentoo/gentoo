# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-r${MY_PV}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="https://github.com/mongodb/mongo-tools/archive/r${MY_PV}.tar.gz -> mongo-tools-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sasl ssl"

# Maintainer note:
# openssl DEPEND constraint, see:
# https://github.com/mongodb/mongo-tools/issues/11

RDEPEND="!<dev-db/mongodb-3.0.0"
DEPEND="${RDEPEND}
	dev-lang/go:=
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.0.0-build.patch"
}

src_compile() {
	local myconf

	if use sasl; then
	  myconf="${myconf} sasl"
	fi

	if use ssl; then
	  myconf="${myconf} ssl"
	fi

	./build.sh ${myconf}
}

src_install() {
	dobin bin/*
}
