# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java-based framework to build multiplatform mail and messaging applications"
HOMEPAGE="https://java.net/projects/javamail/pages/Home"
SRC_URI="https://java.net/projects/javamail/downloads/download/source/javamail-${PV}-src.zip -> ${P}.zip"

# either of these
LICENSE="CDDL GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="
	app-arch/unzip
	virtual/jdk:1.8
"

RDEPEND="virtual/jre:1.8"

S="${WORKDIR}"

src_unpack() {
	default

	# build.xml expects it here
	mkdir -p legal/src/main/resources/META-INF || die
	cp mail/src/main/resources/META-INF/LICENSE.txt \
		legal/src/main/resources/META-INF || die
}

EANT_DOC_TARGET="docs"
EANT_EXTRA_ARGS="-Dspec.dir=doc/spec"
JAVA_PKG_BSFIX="off" #https://bugs.gentoo.org/698954

src_install() {
	java-pkg_dojar target/release/mail.jar

	dodoc doc/release/{CHANGES,COMPAT,NOTES,NTLMNOTES,README,SSLNOTES}.txt
	dohtml -r doc/release/{*.html,images}

	use doc && java-pkg_dojavadoc target/release/docs/javadocs
	use source && java-pkg_dosrc mail/src/main/java
}
