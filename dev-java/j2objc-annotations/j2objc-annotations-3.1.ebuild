# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.j2objc:j2objc-annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for the J2ObjC Java to Objective-C translator"
HOMEPAGE="https://developers.google.com/j2objc/"
SRC_URI="https://github.com/google/j2objc/archive/${PV}.tar.gz -> j2objc-${PV}.tar.gz"
S="${WORKDIR}/j2objc-${PV}/annotations"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,README}.md )
JAVA_INTERMEDIATE_JAR_NAME="com.google.j2objc.annotations"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	rm Makefile || die

	# Upstream builds it as META-INF/versions/9/module-info.class
	mkdir -p src/main/java9 || die "mkdir java9"
	mv src/main/java{,9}/module-info.java || die "move module-info.java"
}
