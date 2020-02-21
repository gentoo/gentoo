# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit distutils-r1

DESCRIPTION="A generic library for injecting 802.11 frames"
HOMEPAGE="http://802.11ninja.net/lorcon"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://code.google.com/p/lorcon/"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="python"

DEPEND="
	python? ( ${PYTHON_DEPS} )
	dev-libs/libnl:3=
	net-libs/libpcap"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}"/${P}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		cp -R "${S}/" "${WORKDIR}/all"
	fi
	default_src_unpack
}

src_prepare() {
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' pylorcon2/PyLorcon2.c
	use python && distutils-r1_src_prepare
}

src_configure() {
	default_src_configure
}

src_compile() {
	default_src_compile
	if use python; then
		LDFLAGS+=" -L${S}/.libs/"
		cd pylorcon2 || die
		distutils-r1_src_compile
	fi
}

src_install() {
	emake DESTDIR="${ED}" install
	if use python; then
		cd pylorcon2 || die
		distutils-r1_src_install
	fi
}

src_test() {
	:
}
