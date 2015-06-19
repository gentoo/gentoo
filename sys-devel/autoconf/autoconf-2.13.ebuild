# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf/autoconf-2.13.ebuild,v 1.25 2015/03/19 23:49:17 vapier Exp $

EAPI="5"

inherit eutils

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
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
)

if [[ -z ${__EBLITS__} && -n ${FILESDIR} ]] ; then
	source "${FILESDIR}"/eblits/main.eblit || die
fi
src_prepare()   { eblit-run src_prepare   ; }
src_install()   { eblit-run src_install   ; }

src_configure() {
	touch configure # make sure configure is newer than configure.in

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
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--program-suffix="-${PV}"
}
