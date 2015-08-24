# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

# For usex.
inherit eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.gnu.org/${PN}.git
		http://git.savannah.gnu.org/r/${PN}.git"
	inherit git-2
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
		ftp://alpha.gnu.org/pub/gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
fi

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3"
SLOT=$(usex multislot "${PV}" "2.5")
IUSE="emacs multislot"

DEPEND=">=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	multislot? ( !~sys-devel/${P}:0 )
	>=sys-devel/autoconf-wrapper-13"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

if [[ -z ${__EBLITS__} && -n ${FILESDIR} ]] ; then
	source "${FILESDIR}"/eblits/main.eblit || die
fi
src_prepare()   { eblit-run src_prepare   ; }
src_configure() { eblit-run src_configure ; }
src_install()   { eblit-run src_install   ; }
