# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/pdf-renderer/pdf-renderer-1.0.5.ebuild,v 1.1 2014/02/19 18:01:02 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="a 100% Java PDF renderer and viewer"
HOMEPAGE="https://java.net/projects/pdf-renderer"
SRC_URI="http://repo1.maven.org/maven2/org/swinglabs/${PN}/${PV}/${P}-sources.jar"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"
