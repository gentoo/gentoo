# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/perl
	sys-devel/m4
	test? ( dev-util/dejagnu )
"
RDEPEND="
	${BDEPEND}
	sys-apps/texinfo
	>=dev-build/autoconf-wrapper-13
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-destdir.patch
	"${FILESDIR}"/${P}-test-fixes.patch #146592
	"${FILESDIR}"/${P}-perl-5.26.patch
	"${FILESDIR}"/${P}-K-R-decls-clang.patch
	"${FILESDIR}"/${P}-Clang-16-fixes-for-various-tests.patch
	"${FILESDIR}"/${P}-skip-AC_FUNC_GETLOADAVG-test.patch
)

src_configure() {
	# make sure configure is newer than configure.in
	touch configure || die

	# need to include --exec-prefix and --bindir or our
	# DESTDIR patch will trigger sandbox hate :(
	#
	# need to force locale to C to avoid bugs in the old
	# configure script breaking the install paths #351982
	#
	# force to `awk` so that we don't encode another awk that
	# happens to currently be installed, but might later be
	# uninstalled (like mawk).  same for m4.
	ac_cv_path_M4="m4" \
	ac_cv_prog_AWK="awk" \
	LC_ALL=C \
	econf \
		--exec-prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--program-suffix="-${PV}" \
		--infodir="${TC_AUTOCONF_INFOPATH}"
}

src_install() {
	toolchain-autoconf_src_install

	# dissuade Portage from removing our dir file
	touch "${ED}"/usr/share/${P}/info/.keepinfodir || die
}
