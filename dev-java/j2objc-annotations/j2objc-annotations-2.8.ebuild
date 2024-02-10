# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
# Yes. version is "2.2" regardless ${PV} being "2.8".
# See https://github.com/google/j2objc/blob/2.8/annotations/pom.xml#L32-L35
MAVEN_ID="com.google.j2objc:j2objc-annotations:2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for the J2ObjC Java to Objective-C translator"
HOMEPAGE="https://developers.google.com/j2objc/"
SRC_URI="https://github.com/google/j2objc/archive/${PV}.tar.gz -> j2objc-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="virtual/jdk:1.8"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,README}.md )

S="${WORKDIR}/j2objc-${PV}/annotations"

JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	rm Makefile || die
}
