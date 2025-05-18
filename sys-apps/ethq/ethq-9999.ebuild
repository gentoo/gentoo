# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

MY_PV=${PV//./_}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Ethernet NIC Queue stats viewer"
HOMEPAGE="https://github.com/isc-projects/ethq"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/isc-projects/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/isc-projects/ethq/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# respect FLAGS, remove Werror and strip
	sed -i  -e '/CXXFLAGS/s/= -O3/+=/' \
		-e '/CXXFLAGS/s/ -Werror//' \
		-e '/LDFLAGS/s/= -s/+=/' Makefile || die "sed failed for Makefile"

	if ! use test ; then
		sed -i '/TARGETS/s/ethq_test//' Makefile \
			|| die "sed failed for USE flag test"
	fi
}

src_test() {
	local driver
	for driver in tests/* ; do
		edo "${S}"/ethq_test "$(basename "${driver%%-*}")" "${driver}"
	done
}

src_install() {
	einstalldocs
	dobin ethq
}
