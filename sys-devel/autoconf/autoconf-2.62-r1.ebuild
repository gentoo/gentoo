# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=">=sys-devel/m4-1.4.6
	dev-lang/perl"
RDEPEND="${DEPEND}
	!~sys-devel/${P}:0
	>=sys-devel/autoconf-wrapper-13"

PATCHES=(
	"${FILESDIR}"/${P}-revert-AC_C_BIGENDIAN.patch #228825
	"${FILESDIR}"/${P}-at-keywords.patch
	"${FILESDIR}"/${P}-fix-multiline-string.patch #217976
)

if [[ -z ${__EBLITS__} && -n ${FILESDIR} ]] ; then
	source "${FILESDIR}"/eblits/main.eblit || die
fi
src_prepare()   { eblit-run src_prepare   ; }
src_configure() { eblit-run src_configure ; }
src_install()   { eblit-run src_install   ; }
