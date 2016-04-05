# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

MY_PN="${PN}-external"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache XML Commons"
HOMEPAGE="http://xml.apache.org/commons/"
SRC_URI="mirror://apache/xerces/${PN}/source/${MY_P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-1.1 public-domain W3C-document W3C"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_SRC_DIR="org javax"
