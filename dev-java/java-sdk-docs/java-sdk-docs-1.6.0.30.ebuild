# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit versionator

UPDATE_VER="$(get_version_component_range 4)"

SRC_URI="jdk-6u${UPDATE_VER}-apidocs.zip"
DESCRIPTION="Sun's documentation bundle (including API) for Java SE"
HOMEPAGE="http://download.oracle.com/javase/6/docs/index.html"
LICENSE="oracle-java-documentation"
SLOT="1.6.0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""
RESTRICT="fetch"

DOWNLOAD_URL="http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u25-doc-download-355137.html"
S="${WORKDIR}/docs"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from "
	einfo "${DOWNLOAD_URL}"
	einfo "(yes, the download page URL refers to an older version for some reason)"
	einfo "(agree to the license) and place it in ${DISTDIR}"

	einfo "If you find the file on the download page replaced with a higher"
	einfo "version, please report to the bug 67266 (link below)."
	einfo "If emerge fails because of a checksum error it is possible that"
	einfo "the upstream release changed without renaming. Try downloading the file"
	einfo "again (or a newer revision if available). Otherwise report this to"
	einfo "https://bugs.gentoo.org/67266 and we will make a new revision."
}

src_install(){
	insinto /usr/share/doc/${P}/html
	doins index.html

	for i in *; do
		[[ -d $i ]] && doins -r $i
	done
}
