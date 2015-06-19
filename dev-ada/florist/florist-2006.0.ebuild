# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/florist/florist-2006.0.ebuild,v 1.5 2008/01/23 22:22:31 george Exp $

inherit gnat libtool

IUSE=""

DESCRIPTION="Posix bindings for Ada"
HOMEPAGE="http://libre2.adacore.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/ada"

lib_compile()
{
	elibtoolize
	econf || die "econf failed"
	emake || die "make failed"
	make floristlib || die "building library failed"
	einfo "lib_compile completed"
}

# NOTE: we are using $1 - the passed gnat profile name
lib_install()
{
	# install goal is just (access violating) mkdir and 2 cp's
	# instead move stuff properly here
	cp -rp ${SL}/floristlib/{libflorist.a,*.ali} ${DL}
	chmod 0444 ${DL}/*.ali
}

src_install ()
{
	# install sources
	dodir ${AdalibSpecsDir}/${PN}
	insinto ${AdalibSpecsDir}/${PN}
	doins -r *.ad{b,s} *.c *.gpb gnatsocks/

	#set up environment
	#echo "PATH=%DL%/bin" > ${LibEnv}
	echo "LDPATH=%DL%" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=/usr/include/ada/${PN}" >> ${LibEnv}

	gnat_src_install

	dodoc README
}
