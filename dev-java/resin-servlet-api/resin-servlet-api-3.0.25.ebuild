# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Resin Servlet API 2.4/JSP API 2.0 implementation"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.zip
	mirror://gentoo/resin-gentoo-patches-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="2.4"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4:*"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}/resin-${PV}"

EANT_BUILD_TARGET="jsdk"
EANT_DOC_TARGET=""

src_prepare() {
	default

	mkdir lib || die
	eapply "${WORKDIR}/${PV}/resin-${PV}-build.xml.patch"
}

src_install() {
	java-pkg_newjar "lib/jsdk-24.jar"
	use source && java-pkg_dosrc "${S}"/modules/jsdk/src/*
}
