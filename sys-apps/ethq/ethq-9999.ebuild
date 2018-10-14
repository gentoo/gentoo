# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/isc-projects/${PN}.git"

inherit git-r3 toolchain-funcs

DESCRIPTION="Ethernet NIC Queue stats viewer"
HOMEPAGE="https://github.com/isc-projects/ethq"
SRC_URI=""

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="sys-libs/ncurses:0"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Respect FLAGS
	sed -i -e '/CXXFLAGS/s/= -O3/+=/' \
		-e '/LDFLAGS/s/=/+=/' Makefile || die "sed failed for Makefile"

	if ! use test ; then
		sed -i '/TARGETS/s/ethq_test//' Makefile \
			|| die "sed failed for USE flag test"
	fi
}

src_compile() {
	# override for ncurses[tinfo]
	emake CXX="$(tc-getCXX)" LIBS_CURSES="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_test() {
	local driver
	for driver in tests/* ; do
		"${S}"/ethq_test "${driver##*/}" "${driver}" \
			|| die "test failed on ${driver}"
	done
}

src_install() {
	einstalldocs
	dobin ethq
}
