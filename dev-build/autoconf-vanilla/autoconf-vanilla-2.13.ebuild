# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-autoconf

MY_PN=${PN/-vanilla}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
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
	"${FILESDIR}"/${MY_P}-gentoo.patch
	"${FILESDIR}"/${MY_P}-destdir.patch
	"${FILESDIR}"/${MY_P}-test-fixes.patch #146592
	"${FILESDIR}"/${MY_P}-perl-5.26.patch
)

src_configure() {
	# need to include --exec-prefix and --bindir or our
	#	 DESTDIR patch will trigger sandbox hate :(
	#
	# need to force locale to C to avoid bugs in the old
	# configure script breaking the install paths #351982
	#
	# force to `awk` so that we don't encode another awk that
	#  happens to currently be installed, but might later be
	# uninstalled (like mawk).  same for m4.
	export ac_cv_path_M4="m4" ac_cv_prog_AWK="awk"
	export LC_ALL=C

	toolchain-autoconf_src_configure \
		--exec-prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--datadir="${EPREFIX}"/usr/share/"${P}" \
		--infodir="${TC_AUTOCONF_INFOPATH}"
}
