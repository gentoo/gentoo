# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

IUSE="debug doc"

file_main_orig=ojdbc14.jar
file_main_debug_orig=ojdbc14_g.jar
file_rowset_orig=ocrs12.jar
file_doc_orig=javadoc.tar

file_main=${P}-${file_main_orig}
file_main_debug=${P}-${file_main_debug_orig}
file_rowset=${P}-${file_rowset_orig}
file_doc=${P}-${file_doc_orig}

DESCRIPTION="JDBC 3.0 Drivers for Oracle"
HOMEPAGE="http://www.oracle.com/technology/software/tech/java/sqlj_jdbc/index.html"
DOWNLOAD_PAGE="http://www.oracle.com/technology/software/tech/java/sqlj_jdbc/htdocs/jdbc9201.html"
SRC_URI="
	!debug? ( ${file_main} )
	debug? ( ${file_main_debug} )
	${file_rowset}
	doc? ( ${file_doc} )"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="oracle-jdbc"
SLOT="9.2"
DEPEND=""
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"

S="${WORKDIR}"

determine_files() {
	if use debug; then
		file_main_used=${file_main_debug}
		file_main_used_orig=${file_main_debug_orig}
	else
		file_main_used=${file_main}
		file_main_used_orig=${file_main_orig}
	fi
}

pkg_nofetch() {
	determine_files

	einfo
	einfo " Because of license terms and file name conventions, please:"
	einfo
	einfo " 1. Visit ${DOWNLOAD_PAGE}"
	einfo "    (you may need to create an account on Oracle's site)"
	einfo " 2. Download the appropriate files:"
	einfo "    - ${file_main_used_orig}"
	einfo "    - ${file_rowset_orig}"
	use doc && einfo "    - ${file_doc_orig}"
	einfo " 3. Rename the files:"
	einfo "    - ${file_main_used_orig} --> ${file_main_used}"
	einfo "    - ${file_rowset_orig} --> ${file_rowset}"
	use doc && einfo "    - ${file_doc_orig} --> ${file_doc}"
	einfo " 4. Place the files in ${DISTDIR}"
	einfo " 5. Resume the installation."
	einfo
}

src_unpack() {
	determine_files
	cp "${DISTDIR}/${file_main_used}" ${PN}.jar || die
	cp "${DISTDIR}/${file_rowset}" ${file_rowset_orig} || die

	if use doc; then
		mkdir javadoc && cd javadoc
		unpack ${file_doc}
	fi
}

src_install() {
	java-pkg_dojar *.jar

	use doc && java-pkg_dojavadoc javadoc
}
