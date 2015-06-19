# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-jaf/gnu-jaf-1.1.1.ebuild,v 1.4 2010/02/09 14:42:58 josejx Exp $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="GNU implementation of the JavaBeans Activation Framework"
HOMEPAGE="http://www.gnu.org/software/classpathx/jaf/jaf.html"
SRC_URI="mirror://gnu/classpathx/activation-${PV}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/activation-${PV}

EANT_BUILD_TARGET="activation.jar"

src_install() {
	java-pkg_dojar activation.jar
	dodoc AUTHORS ChangeLog || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc source/*
}
