# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_ANT_ENCODING=UTF-8

[[ ${PV} == "9999" ]] && SUBVERSION_ECLASS="subversion"
ESVN_REPO_URI="http://josm.openstreetmap.de/svn/trunk"
inherit eutils java-pkg-2 java-ant-2 ${SUBVERSION_ECLASS}
unset SUBVERSION_ECLASS

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="http://josm.openstreetmap.de/"
# Upstream doesn't provide versioned tarballs, so we'll have to create one on our own:
# REVISION=${PV}
# mkdir -p josm-${REVISION}
# svn co -r ${REVISION} http://josm.openstreetmap.de/svn/trunk/ josm-${REVISION}
# cd josm-${REVISION} && ant init-svn-revision-xml && cd -
# tar -cz  --exclude=.svn -f /usr/portage/distfiles/josm-${REVISION}.tar.gz josm-${REVISION}
[[ ${PV} == "9999" ]] || SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == "9999" ]] || \
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

IUSE=""

src_prepare() {

	if [[ ${PV} == "9999" ]]; then

		# create-revision needs the compile directory to be a svn directory
		# see also http://lists.openstreetmap.org/pipermail/dev/2009-March/014182.html
		sed -i \
			-e "s:arg[ ]value=\".\":arg value=\"${ESVN_STORE_DIR}\/${PN}\/trunk\":" \
			build.xml || die "sed failed"

	else

		# Remove dependency on git and svn just for generating a
		# revision - the tarball should already have REVISION.XML
		sed -i -e 's:, *init-git-revision-xml::g' \
			-e '/<exec[ \t].*"svn"[ \t].*/,+5{d;n;}' \
			-e 's:${svn.info.result}:1:' \
			build.xml || die "sed failed"

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
