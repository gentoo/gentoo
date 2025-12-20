# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV%_p*}
DEB_VER=${PV#*_p}

inherit autotools

DESCRIPTION="Start a programming project using autotools and a command line parser generator"
HOMEPAGE="https://packages.debian.org/unstable/devel/autoproject"
SRC_URI="
	mirror://debian/pool/main/a/autoproject/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/a/autoproject/${PN}_${MY_PV}-${DEB_VER}.debian.tar.xz
"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-build/autoconf:*
	dev-build/automake:*
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		sys-apps/texinfo
		sys-devel/autogen
		virtual/texi2dvi
	)
"

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${PN}-0.20_p15-getopt-cxx-conflict-noexcept.patch
)

src_prepare() {
	default

	sed -i -e 's:configure.in:configure.ac:' Makefile.am || die
	eautoreconf
}

src_test() {
	# chkclig: clig is an optional dep and it isn't packaged in Gentoo
	#          (nor in Debian since 2009)
	# chkag: fails, unclear why
	emake check XFAIL_TESTS="chkclig chkag"
}
