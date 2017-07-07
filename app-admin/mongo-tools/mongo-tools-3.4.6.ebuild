# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
IUSE="sasl ssl libressl"

# Maintainer note:
# openssl DEPEND constraint, see:
# https://github.com/mongodb/mongo-tools/issues/11

RDEPEND="!<dev-db/mongodb-3.0.0"
DEPEND="${RDEPEND}
	dev-lang/go:=
	net-libs/libpcap
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e 's|go build .*|go build -o "bin/$i" -tags "$tags" "$i/main/$i.go"|g' -i build.sh || die

	# ensure we use bash wrt #582906
	sed -e 's@/bin/sh@/bin/bash@g' -i build.sh || die

	epatch "${FILESDIR}/${PN}-3.2.10-pie.patch"
}

src_compile() {
	local myconf

	if use sasl; then
	  myconf="${myconf} sasl"
	fi

	if use ssl; then
	  myconf="${myconf} ssl"
	fi

	./build.sh ${myconf} || die "build failed"
}

src_install() {
	dobin bin/*
}
