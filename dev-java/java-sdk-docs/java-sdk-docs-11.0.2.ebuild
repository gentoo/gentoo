# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOWNLOAD_URL="https://www.oracle.com/technetwork/java/javase/documentation/jdk11-doc-downloads-5097203.html"

SLOT="${PV%%.*}"
DESCRIPTION="Oracle's documentation bundle (including API) for Java SE"
HOMEPAGE="https://docs.oracle.com/javase/${SLOT}"
SRC_URI="jdk-${PV}_doc-all.zip"
LICENSE="oracle-java-documentation-${SLOT}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="fetch"

DEPEND="app-arch/unzip"

S="${WORKDIR}/docs"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from"
	einfo "${DOWNLOAD_URL}"
	einfo "by agreeing to the license and place it in your distfiles directory."
	einfo ""
	einfo "If you find the file on the download page replaced with a higher"
	einfo "version, please report it in bug #67266 (link below)."
	einfo ""
	einfo "If emerge fails because of a checksum error, it is possible that"
	einfo "the upstream release changed without renaming. Try downloading the file"
	einfo "again (or a newer revision if available). Otherwise report this to"
	einfo "https://bugs.gentoo.org/67266 and we will make a new revision."
}

src_install() {
	insinto /usr/share/doc/${PN}-${SLOT}/html
	doins -r index.html */
}
