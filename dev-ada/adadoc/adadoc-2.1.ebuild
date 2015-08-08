# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils gnat

DESCRIPTION="A tool for Ada95 to create documentation from specification packages"

HOMEPAGE="http://adadoc.sourceforge.net"

SRC_URI="mirror://sourceforge/adadoc/${PN}-v${PV}.src.tar.bz2
	mirror://sourceforge/adadoc/UserGuide.pdf
	mirror://sourceforge/adadoc/HowToWriteModule.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="virtual/ada
	>=dev-ada/xmlada-1.0-r2"

RDEPEND=""

S=${WORKDIR}/dev

lib_compile() {
	${ADAMAKE} adadoc -Itools -Iparser -Imodules -cargs ${ADACFLAGS} -bargs -shared \
		`xmlada-config` ||  die
}

lib_install() {
	cp adadoc ${DL}
}

src_install() {
	#set up environment
	echo "PATH=%DL%" > ${LibEnv}
	echo "LDPATH=%DL%" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=/usr/include/ada/${PN}" >> ${LibEnv}

	gnat_src_install

	insinto /usr/share/doc/adadoc-${PV}
	doins "${DISTDIR}"/UserGuide.pdf
	doins "${DISTDIR}"/HowToWriteModule.pdf
	insinto /usr/share/adadoc
	doins adadoc_tags.cfg
}

pkg_postinst() {
	eselect gnat update
	elog "The environment has been set up to make gnat automatically find files for"
	elog "${PN}. In order to immediately activate these settings please do:"
	elog "env-update && source /etc/profile"
	elog "Otherwise the settings will become active next time you login"
}
