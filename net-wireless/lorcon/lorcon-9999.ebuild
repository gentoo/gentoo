# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit distutils-r1

DESCRIPTION="A generic library for injecting 802.11 frames"
HOMEPAGE="https://github.com/kismetwireless/lorcon"

if [[ ${PV} == "9999" ]] ; then
	#EGIT_REPO_URI="https://www.kismetwireless.net/lorcon.git"
	EGIT_REPO_URI="https://github.com/kismetwireless/lorcon.git"
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}"/${P}
else
	GIT_HASH="d8637792f2e857f31849f29759c1022eb0518c83"
	SRC_URI="https://github.com/kismetwireless/lorcon/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/"${PN}-${GIT_HASH}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
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

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		cp -R "${S}/" "${WORKDIR}/all"
	fi
	default_src_unpack
}

src_prepare() {
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' pylorcon2/PyLorcon2.c
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' pylorcon2/PyLorcon2.h
	sed -i 's#<lorcon2/lorcon_packet.h>#"../lorcon_packet.h"#' pylorcon2/PyLorcon2.c
	sed -i 's#<lorcon2/lorcon_packet.h>#"../lorcon_packet.h"#' pylorcon2/PyLorcon2.h
	sed -i 's#<lorcon2/lorcon_multi.h>#"../lorcon_multi.h"#' pylorcon2/PyLorcon2.c
	sed -i 's#<lorcon2/lorcon_multi.h>#"../lorcon_multi.h"#' pylorcon2/PyLorcon2.h
	default
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
