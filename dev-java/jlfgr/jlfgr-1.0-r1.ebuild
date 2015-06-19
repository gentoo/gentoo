# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jlfgr/jlfgr-1.0-r1.ebuild,v 1.5 2013/04/16 18:48:03 ulm Exp $

inherit versionator java-pkg-2

MY_PV=$(replace_all_version_separators '_')
DESCRIPTION="Java(TM) Look and Feel Graphics Repository"
HOMEPAGE="http://java.sun.com/developer/techDocs/hi/repository/"
SRC_URI="mirror://gentoo/jlfgr-${MY_PV}.zip"

LICENSE="sun-jlfgr"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
S=${WORKDIR}

# Empty src_compile() to prevent message about not found build.xml
src_compile() { :; }

src_install() {
	java-pkg_newjar jlfgr-${MY_PV}.jar ${PN}.jar
}
