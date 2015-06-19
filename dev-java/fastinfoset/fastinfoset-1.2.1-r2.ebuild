# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastinfoset/fastinfoset-1.2.1-r2.ebuild,v 1.1 2014/09/06 16:18:43 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Fast Infoset specifies a standardized binary encoding for the XML Information Sets"
HOMEPAGE="https://fi.java.net/"
SRC_URI="https://fi.dev.java.net/files/documents/2634/45735/FastInfoset_src_${PV}.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"
