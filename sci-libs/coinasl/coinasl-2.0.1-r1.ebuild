# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Ampl Solver Library (ASL)"
HOMEPAGE="https://github.com/coin-or-tools/ThirdParty-ASL"
BUILD_TOOLS_VERSION="20208f47f7bbc0056a92adefdfd43fded969f674"
SOLVERS_SHA="ae937db9bd1169ec2c4cb8d75196f67cdcb8041b"
SRC_URI="https://github.com/ampl/asl/archive/${SOLVERS_SHA}.tar.gz -> solvers-${SOLVERS_SHA}.tar.gz
	https://github.com/coin-or-tools/ThirdParty-ASL/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/coin-or-tools/BuildTools/archive/${BUILD_TOOLS_VERSION}.tar.gz -> coin-or-tools-BuildTools-${BUILD_TOOLS_VERSION}.tar.gz"
S="${WORKDIR}/ThirdParty-ASL-releases-${PV}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	# See 943309. Patch merged upstream https://github.com/coin-or-tools/ThirdParty-ASL/pull/7
	"${FILESDIR}/${P}-getrusage.patch"
)

src_unpack() {
	default
	mv "asl-${SOLVERS_SHA}/src/solvers" "${S}" || die
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
