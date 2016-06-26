# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
SCONS_MIN_VERSION="2.3.0"

inherit eutils flag-o-matic multilib scons-utils

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-cxx-driver"
SRC_URI="https://github.com/mongodb/${PN}/archive/legacy-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libressl sasl ssl static-libs"

RDEPEND="!dev-db/tokumx
	>=dev-libs/boost-1.50[threads(+)]
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

# Maintainer notes
# TODO: enable test in IUSE with
# test? ( >=dev-cpp/gtest-1.7.0 dev-db/mongodb )

DOCS=( README.md )

S="${WORKDIR}/${PN}-legacy-${PV}"

pkg_setup() {
	scons_opts="--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX)"
	scons_opts+=" --disable-warnings-as-errors --sharedclient"

	if use debug; then
		scons_opts+=" --dbg=on"
	fi

	if use prefix; then
		scons_opts+=" --cpppath=${EPREFIX}/usr/include"
		scons_opts+=" --libpath=${EPREFIX}/usr/$(get_libdir)"
	fi

	if use sasl; then
		scons_opts+=" --use-sasl-client"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.0-fix-scons.patch"

	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi
}

src_install() {
	escons ${scons_opts} install --prefix="${ED}"/usr

	use static-libs || find "${D}" -name '*.a' -delete
}
