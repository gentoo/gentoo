# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_ANT_ENCODING=UTF-8

[[ ${PV} == "99999" ]] && SUBVERSION_ECLASS="subversion"
ESVN_REPO_URI="https://josm.openstreetmap.de/svn/trunk"
inherit eutils java-pkg-2 java-ant-2 ${SUBVERSION_ECLASS}
unset SUBVERSION_ECLASS

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="https://josm.openstreetmap.de/"
[[ ${PV} == "99999" ]] || SRC_URI="http://josm.hboeck.de/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == "99999" ]] || \
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

IUSE=""

src_prepare() {
	if [[ ${PV} == "99999" ]]; then

		# create-revision needs the compile directory to be a svn directory
		# see also https://lists.openstreetmap.org/pipermail/dev/2009-March/014182.html
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
