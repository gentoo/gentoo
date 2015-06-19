# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/josm/josm-9999.ebuild,v 1.4 2014/09/06 19:37:21 nixphoeni Exp $

EAPI=5

JAVA_ANT_ENCODING=UTF-8

[[ ${PV} == "9999" ]] && SUBVERSION_ECLASS="subversion"
ESVN_REPO_URI="http://josm.openstreetmap.de/svn/trunk"
inherit eutils java-pkg-2 java-ant-2 ${SUBVERSION_ECLASS}
unset SUBVERSION_ECLASS

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="http://josm.openstreetmap.de/"
[[ ${PV} == "9999" ]] || SRC_URI="http://josm.hboeck.de/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == "9999" ]] || \
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${P}"

IUSE=""

src_prepare() {
	if [[ ${PV} == "9999" ]]; then

		# create-revision needs the compile directory to be a svn directory
		# see also http://lists.openstreetmap.org/pipermail/dev/2009-March/014182.html
		sed -i \
			-e "s:arg[ ]value=\".\":arg value=\"${ESVN_STORE_DIR}\/${PN}\/trunk\":" \
			build.xml || die "Sed failed"
	fi
}

src_compile() {
	eant dist-optimized
}

src_install() {
	java-pkg_newjar "dist/${PN}-custom-optimized.jar" "${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	newicon images/logo.png josm.png || die "newicon failed"
	make_desktop_entry "${PN}" "Java OpenStreetMap Editor" josm "Utility;Science;Geoscience"
}
