# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-r${MY_PV}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.org"
SRC_URI="https://github.com/mongodb/mongo-tools/archive/r${MY_PV}.tar.gz -> mongo-tools-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sasl ssl"

RDEPEND="!<dev-db/mongodb-3.0.0"
DEPEND="${RDEPEND}
	dev-lang/go:=
	net-libs/libpcap
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( dev-libs/openssl:0= )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# do not substitute version because it uses git
	sed -i '/^sed/,+3d' build.sh || die
	sed -i '/^mv/d' build.sh || die

	# build pie to avoid text relocations wrt #582854
	# skip on ppc64 wrt #610984
	if ! use ppc64; then
		sed -i 's/\(go build\)/\1 -buildmode=pie/g' build.sh || die
	fi

	# ensure we use bash wrt #582906
	sed -i 's@/bin/sh@/bin/bash@g' build.sh || die
}

src_compile() {
	local myconf=()

	if use sasl; then
	  myconf+=(sasl)
	fi

	if use ssl; then
	  myconf+=(ssl)
	fi

	./build.sh ${myconf[@]} || die "build failed"
}

src_install() {
	dobin bin/*
}
