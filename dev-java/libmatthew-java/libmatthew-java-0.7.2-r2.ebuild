# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 flag-o-matic toolchain-funcs

DESCRIPTION="A selection of libraries for Java"
HOMEPAGE="http://www.matthew.ath.cx/projects/java/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND="
	>=virtual/jre-1.5"

DEPEND="
	>=virtual/jdk-1.5"

PATCHES=( "${FILESDIR}"/${P}-makefile-fixes.patch )
DOCS=( INSTALL changelog README )

src_prepare() {
	default
	sed -i -e '167d;' cx/ath/matthew/unix/UnixSocket.java || die "sed failed"
	rm -v "${S}"/cx/ath/matthew/debug/Debug.java || die "rm failed"
}

src_compile() {
	CC=$(tc-getCC) \
		LD=$(tc-getCC) \
		INCLUDES="$(java-pkg_get-jni-cflags)" \
		emake -j1 \
		JARDIR=/usr/share/libmatthew-java/lib \
		JCFLAGS="$(java-pkg_javac-args)" \
		all \
		$(usev doc)
}

src_install() {
	java-pkg_newjar cgi-0.5.jar cgi.jar
	java-pkg_newjar debug-disable-1.1.jar debug-disable.jar
	java-pkg_newjar debug-enable-1.1.jar debug-enable.jar
	java-pkg_newjar hexdump-0.2.jar hexdump.jar
	java-pkg_newjar io-0.1.jar io.jar
	java-pkg_newjar unix-0.5.jar unix.jar
	java-pkg_doso libcgi-java.so
	java-pkg_doso libunix-java.so
	einstalldocs
	use source && java-pkg_dosrc cx/
	use doc && java-pkg_dojavadoc doc
}
