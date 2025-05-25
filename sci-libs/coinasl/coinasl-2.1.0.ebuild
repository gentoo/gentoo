# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Ampl Solver Library (ASL)"
HOMEPAGE="https://github.com/coin-or-tools/ThirdParty-ASL"
BUILD_TOOLS_VERSION="20208f47f7bbc0056a92adefdfd43fded969f674"
SOLVERS_VERSION="1.0.1"
SRC_URI="https://github.com/ampl/asl/archive/refs/tags/v${SOLVERS_VERSION}.tar.gz -> solvers-${SOLVERS_VERSION}.tar.gz
	https://github.com/coin-or-tools/ThirdParty-ASL/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/coin-or-tools/BuildTools/archive/${BUILD_TOOLS_VERSION}.tar.gz -> coin-or-tools-BuildTools-${BUILD_TOOLS_VERSION}.tar.gz"
S="${WORKDIR}/ThirdParty-ASL-releases-${PV}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

src_unpack() {
	default
	mv "asl-${SOLVERS_VERSION}/src/solvers" "${S}" || die
}

src_prepare() {
	default
	AT_M4DIR="${WORKDIR}/BuildTools-${BUILD_TOOLS_VERSION}"
	eautoreconf
}

src_configure() {
	econf --enable-shared
}

src_install() {
	default
	rm "${D}/usr/$(get_libdir)/libcoinasl.la" || die
}
