# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tablelayout/tablelayout-20090826.ebuild,v 1.2 2015/04/02 18:19:37 mr_bones_ Exp $

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="TableLayout is a powerful layout manager"
HOMEPAGE="https://java.net/projects/tablelayout/"
SRC_URI="https://java.net/projects/tablelayout/downloads/download/Everything-2009-08-26.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"

JAVA_SRC_DIR="src"

java_prepare() {
	unzip TableLayout-src-2009-08-26.jar -d src || die
	rm *.jar || die
}
