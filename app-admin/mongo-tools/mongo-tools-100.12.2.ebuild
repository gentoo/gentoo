# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://github.com/mongodb/mongo-tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="kerberos test-full"

RDEPEND="
	kerberos? ( app-crypt/mit-krb5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test-full? ( dev-db/mongodb )
"

src_compile() {
	local myconf=()

	if use kerberos; then
		myconf+=(gssapi)
	fi

	mkdir -p bin || die
	for i in bsondump mongostat mongofiles mongoexport mongoimport mongorestore mongodump mongotop; do
		einfo "Building $i"
		ego build -o "bin/$i" -ldflags "-X main.VersionStr=${PV}" -x --tags "${myconf[*]}" "$i/main/$i.go"
	done
}

src_test() {
	# https://github.com/mongodb/mongo-tools/blob/master/CONTRIBUTING.md#testing
	ego run build.go test:unit

	if use test-full; then
		mongod --setParameter enableTestCommands=1 --port 33333 \
			--fork --dbpath="${T}" --logpath="${T}/mongod.log" || die
		ego run build.go test:integration
		kill $(<"${T}/mongod.lock")
	fi
}

src_install() {
	dobin bin/*
	einstalldocs
}
