# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs flag-o-matic
MY_P="${P}"

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
HOMEPAGE="http://accellera.org/community/systemc"
SRC_URI="http://www.accellera.org/images/downloads/standards/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
IUSE="doc static-libs"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

CUSTOM_CXX_STD="$(get-flag -std)"

src_configure() {
	# If user sets their own C++ standard, do not interfere
	if [ -z "${CUSTOM_CXX_STD}" ]; then
		append-cxxflags -std=c++14
		append-cxxflags -DSC_CPLUSPLUS=201402L
	fi
	econf $(use_enable static-libs static) CXX=$(tc-getCXX) \
	--with-unix-layout
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL NEWS README RELEASENOTES
	rm docs/Makefile* || die
	use doc && dodoc -r docs/*
	cd src
	default
}

pkg_postinst() {
	elog "If you want to run the examples, you need to :"
	elog "    tar xvfz ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	elog "    cd ${MY_P}"
	elog "    find examples -name 'Makefile.*' -exec sed -i -e 's/-lm/-lm -lpthread/' '{}' \;"
	elog "    ./configure"
	elog "    cd examples"
	elog "    make check"
	if [ -n "${CUSTOM_CXX_STD}" ]; then
		ewarn "You set a custom C++ standard for this ebuild. This is unsupported and may introduce breakage."
		ewarn "Consult the SystemC manual for which Macro definitions you have to set for this to work."
	fi
}
