# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java-based framework to build multiplatform mail and messaging applications"
HOMEPAGE="http://java.sun.com/products/javamail/index.html"
SRC_URI="mirror://gentoo/javamail-${PV}-src.zip -> ${P}.zip"

LICENSE="|| ( CDDL GPL-2 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="mail"

HTML_DOCS=( doc/release )

src_prepare() {
	default
	rm -rv mail/src/test || die
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs
}
