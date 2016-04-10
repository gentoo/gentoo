# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/aerospike/aerospike-server.git"

inherit git-2 systemd user

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+tools"

RDEPEND="app-crypt/gcr
	dev-libs/jansson
	dev-libs/jemalloc"
DEPEND="${RDEPEND}"

DOCS=(
	README.md
)

PATCHES=(
	"${FILESDIR}"/3.5.8-use-system-libs.patch
)

pkg_setup() {
	enewgroup aerospike
	enewuser aerospike -1 /bin/bash /opt/aerospike aerospike
}

src_prepare() {
	base_src_prepare

	git submodule update --init

	sed \
		-e 's/USE_SYSTEM_JEM = 0/USE_SYSTEM_JEM = 1/g' \
		-e 's/USE_SYSTEM_JANSSON = 0/USE_SYSTEM_JANSSON = 1/g' \
		-e 's/LD_CRYPTO = static/LD_CRYPTO = dynamic/g' \
		-e 's/LD_JANSSON = static/LD_JANSSON = dynamic/g' \
		-e 's/LD_JEM = static/LD_JEM = dynamic/g' \
		-i make_in/Makefile.vars || die

	rm -rf modules/jansson
	rm -rf modules/jemalloc
}

src_install() {
	base_src_install_docs

	dobin target/Linux-x86_64/bin/asd

	insinto /opt/aerospike/sys/udf/lua
	doins -r modules/lua-core/src/*

	if use tools; then
		insinto /opt/aerospike/bin
		doins tools/afterburner/afterburner.sh
		fperms +x /opt/aerospike/bin/afterburner.sh
	fi

	keepdir /opt/aerospike/usr/udf/lua
	keepdir /var/log/aerospike

	insinto /etc/aerospike
	for conf in aerospike.conf aerospike_mesh.conf aerospike_ssd.conf; do
		sed -e "s@/var/run/aerospike/asd.pid@/run/aerospike/aerospike.pid@g" -i as/etc/"${conf}" || die
		doins as/etc/"${conf}"
	done

	insinto /etc/logrotate.d
	newins as/etc/logrotate_asd aerospike

	newinitd "${FILESDIR}"/aerospike.init aerospike
	systemd_newunit as/etc/aerospike-server.service aerospike.service

	fowners -R aerospike:aerospike /opt/aerospike/
	fowners aerospike:aerospike /usr/bin/asd
	fowners -R aerospike:aerospike /var/log/aerospike
}
