# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A reference implementation of the Russian GOST crypto algorithms for OpenSSL"
HOMEPAGE="https://github.com/gost-engine/engine"

SLOT="0/${PV}"

DEPEND=">=dev-libs/openssl-1.1:0="
RDEPEND="${DEPEND}"

LICENSE="openssl"

DOCS=( INSTALL.md README.gost README.md )

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/gost-engine/engine.git"
	inherit git-r3
else
	KEYWORDS="amd64"
	SRC_URI="https://github.com/gost-engine/engine/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/engine-${PV}"
fi
