# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-bin}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="The MongoDB Shell"
HOMEPAGE="https://github.com/mongodb-js/mongosh https://www.mongodb.com/products/shell"

SRC_URI_BASE="https://downloads.mongodb.com/compass/${MY_P}-linux"
SRC_URI="amd64? ( ${SRC_URI_BASE}-x64.tgz -> ${MY_P}_x64.tgz )
		arm64? ( ${SRC_URI_BASE}-arm64.tgz -> ${MY_P}_arm64.tgz )"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-4.0 ISC MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-libs/cyrus-sasl[kerberos]"

# Do not complain about CFLAGS etc since we don't use them
QA_FLAGS_IGNORED='.*'

src_unpack() {
	if use amd64; then
		S="${WORKDIR}/${MY_P}-linux-x64"
	elif use arm64; then
		S="${WORKDIR}/${MY_P}-linux-arm64"
	fi

	default
}

src_install() {
	dobin bin/mongosh
}
