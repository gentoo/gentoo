# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="userland_BSD"

DEPEND=">=sys-apps/texinfo-4.3
	=sys-devel/m4-1.4*
	dev-lang/perl"
RDEPEND="${DEPEND}
	>=sys-devel/autoconf-wrapper-13"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-destdir.patch
	"${FILESDIR}"/${P}-test-fixes.patch #146592
	"${FILESDIR}"/${PN}-2.13-perl-5.26.patch
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
	local prepend=""
	use userland_BSD && prepend="g"
	ac_cv_path_M4="${prepend}m4" \
	ac_cv_prog_AWK="${prepend}awk" \
	LC_ALL=C \
	econf \
		--exec-prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--program-suffix="-${PV}"
}
