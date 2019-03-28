# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-r${MY_PV}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://github.com/mongodb/mongo-tools/archive/r${MY_PV}.tar.gz -> mongo-tools-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sasl ssl"

DEPEND="dev-lang/go:=
	net-libs/libpcap
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( dev-libs/openssl:0= )"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

EGO_PN="github.com/mongodb/mongo-tools"
S="${WORKDIR}/src/${EGO_PN}"

src_unpack() {
	mkdir -p "${S%/*}" || die
	default
	mv ${MY_P} "${S}" || die
}

src_prepare() {
	default

	# allow building with go 1.12 #678924
	sed -i 's/_Ctype_struct_/C.struct_/' vendor/github.com/google/gopacket/pcap/pcap.go || die
}

src_compile() {
	local myconf=()

	if use sasl; then
		myconf+=(sasl)
	fi

	if use ssl; then
		myconf+=(ssl)
	fi

	# build pie to avoid text relocations wrt #582854
	local buildmode="pie"

	# skip on ppc64 wrt #610984
	if use ppc64; then
		buildmode="default"
	fi

	mkdir -p bin || die
	for i in bsondump mongostat mongofiles mongoexport mongoimport mongorestore mongodump mongotop mongoreplay; do
		echo "Building $i"
		GOROOT="$(go env GOROOT)" GOPATH="${WORKDIR}" go build -buildmode="${buildmode}" -o "bin/$i" \
			-ldflags "-X ${EGO_PN}/common/options.VersionStr=${PV}" --tags "${myconf[*]}" "$i/main/$i.go" || die
	done
}

src_install() {
	dobin bin/*
}
