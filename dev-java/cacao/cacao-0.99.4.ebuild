# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools eutils flag-o-matic java-pkg-2 java-vm-2

DESCRIPTION="Cacao Java Virtual Machine"
HOMEPAGE="http://www.cacaojvm.org/"
SRC_URI="http://www.complang.tuwien.ac.at/cacaojvm/download/${P}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
CLASSPATH_SLOT=0.98
COMMON_DEPEND="
	dev-java/gnu-classpath:${CLASSPATH_SLOT}
	|| ( dev-java/eclipse-ecj dev-java/ecj-gcj )
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-java/junit:4
		${AUTOTOOLS_DEPEND}
	)
"

CLASSPATH_DIR=/usr/gnu-classpath-${CLASSPATH_SLOT}

src_prepare() {
	if use test; then
		sed -ie "s:/usr/share/java/junit4.jar:$(java-config -p junit-4):" \
			./tests/regression/bugzilla/Makefile.am \
			./tests/regression/base/Makefile.am || die "sed failed"
		eautoreconf
	fi
}

src_configure() {
	# A compiler can be forced with the JAVAC variable if needed
	unset JAVAC
	append-flags -fno-strict-aliasing
	econf --bindir=/usr/${PN}/bin \
		--libdir=/usr/${PN}/lib \
		--datarootdir=/usr/${PN}/share \
		--disable-dependency-tracking \
		--with-java-runtime-library-prefix=${CLASSPATH_DIR}
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodir /usr/bin
	dosym /usr/${PN}/bin/cacao /usr/bin/cacao || die
	dodoc AUTHORS ChangeLog* NEWS README || die "failed to install docs"

	for files in ${CLASSPATH_DIR}/bin/g*; do
		dosym $files \
			/usr/${PN}/bin/$(echo $files|sed "s#$(dirname $files)/g##") || die
	done

	dodir /usr/${PN}/jre/lib
	dosym ${CLASSPATH_DIR}/share/classpath/glibj.zip /usr/${PN}/jre/lib/rt.jar
	dodir /usr/${PN}/lib
	dosym ${CLASSPATH_DIR}/share/classpath/tools.zip /usr/${PN}/lib/tools.jar

	dosym /usr/bin/ecj /usr/${PN}/bin/javac || die

	local libarch="${ARCH}"
	[ ${ARCH} == x86 ] && libarch="i386"
	[ ${ARCH} == x86_64 ] && libarch="amd64"
	dodir /usr/${PN}/jre/lib/${libarch}/client
	dodir /usr/${PN}/jre/lib/${libarch}/server
	dosym /usr/${PN}/lib/libjvm.so /usr/${PN}/jre/lib/${libarch}/client/libjvm.so
	dosym /usr/${PN}/lib/libjvm.so /usr/${PN}/jre/lib/${libarch}/server/libjvm.so
	dosym ${CLASSPATH_DIR}/lib/classpath/libjawt.so /usr/${PN}/jre/lib/${libarch}/libjawt.so
	set_java_env
}
