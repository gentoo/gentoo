# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="GNU implementation of the JavaBeans Activation Framework"
HOMEPAGE="https://www.gnu.org/software/classpathx/jaf/jaf.html"
SRC_URI="mirror://gnu/classpathx/activation-${PV}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="1"
KEYWORDS="amd64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8"

RDEPEND="
	>=virtual/jre-1.8"

S=${WORKDIR}/activation-${PV}

EANT_BUILD_TARGET="activation.jar"

DOCS=( AUTHORS ChangeLog )

src_install() {
	java-pkg_dojar activation.jar
	einstalldocs
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc source/*
}
