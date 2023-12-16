# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bnd.annotation:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bnd Annotations Library"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/bnd-${PV}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

DEPEND="
	dev-java/osgi-cmpn:8
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="biz.aQute.bnd.annotation"
JAVA_CLASSPATH_EXTRA="osgi-cmpn-8"
JAVA_SRC_DIR="biz.aQute.bnd.annotation/src"
