# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gap-pkg

MY_PN=Browse
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GAP ncurses interface for browsing two-dimensional data"
SLOT="0"
SRC_URI="https://www.math.rwth-aachen.de/homes/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap:=
	sys-libs/ncurses:="
RDEPEND="${DEPEND}"

GAP_PKG_EXTRA_INSTALL=( app bibl )
gap-pkg_enable_tests

src_compile() {
	# This has been emailed upstream but there's no public
	# bug tracker AFAIK.
	append-cflags -Wno-error=strict-prototypes
	gap-pkg_src_compile
}

src_test() {
	# TestPackage doesn't work for this guy. Copy the eclass src_test()
	# and modify it to use TestDirectory() instead of TestPackage().
	local gapcmd="gap -R -A --nointeract -c "
	gapcmd+="LoadPackage(\"${PN}\");"
	gapcmd+="d:=DirectoriesPackageLibrary(\"${PN}\",\"tst\");"
	gapcmd+="TestDirectory(d[1],rec(exitGAP:=true));"
	ln -s "${WORKDIR}" "${T}/pkg" || die
	gapcmd+=" --roots ${T}/; "

	# Even the "tee" pipe from the eclass isn't enough to stop
	# this one from acting wacky, although it doesn't really
	# break the terminal any more. Instead it just enters
	# display mode and wipes your screen for a bit.
	einfo "running test suite quietly to avoid borking your terminal"
	${gapcmd} > test-suite.log \
		|| die "test suite failed, see test-suite.log"
}
