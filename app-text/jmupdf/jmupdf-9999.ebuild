# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jmupdf/jmupdf-9999.ebuild,v 1.1 2013/06/10 12:22:29 xmw Exp $

EAPI=5

inherit eutils flag-o-matic git-2 java-pkg-2 java-ant-2 multilib
EANT_BUILD_TARGET=${PN}

DESCRIPTION="Java library for rendering PDF, XPS and CBZ (Comic Book) documents"
HOMEPAGE="https://code.google.com/p/jmupdf/"
EGIT_REPO_URI="https://code.google.com/p/${PN}/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE="system-mupdf"

REQUIRED_USE="!system-mupdf"

RDEPEND="system-mupdf? ( >=app-text/mupdf-1.2 )
	virtual/jdk:1.7"
DEPEND="${RDEPEND}
	app-arch/p7zip
	media-libs/libbmp"

src_prepare() {
	if ! grep javac ${PN}/build.xml >/dev/null ; then
		epatch \
			"${FILESDIR}"/${PN}-0.4.1-build-xml.patch
	fi

	edos2unix $(find mupdf/jni -type f)

	sed -e "/^JVM_INCLUDES/s:=.*:= $(java-pkg_get-jni-cflags):" \
		-i mupdf/MakeJNI2 || die
	sed -e "s:-pipe -O2::" \
		-i mupdf/Makerules || die

	rm -r mupdf/thirdparty || die
	if use system-mupdf ; then
		for i in android apps cbz cmaps debian draw fitz fonts ios pdf scripts viewer win32 xps ; do
			einfo remove mupdf/${i}
			rm -r mupdf/${i} || die
		done
	fi
}

src_compile() {
	#append-cflags -Ijni/includes
	emake -C mupdf \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		SYS_FREETYPE_INC="$($(tc-getPKG_CONFIG) --cflags freetype2)" \
		JNI_DLL=build/libjmupdf.so \
		JNI_CMD="-shared -Wl,-soname -Wl,lib${PN}.so" \
		build/libjmupdf.so

	cd ${PN}
	java-pkg-2_src_compile
}

src_install() {
	dolib.so mupdf/build/lib${PN}.so

	cd ${PN}
	java-pkg_dojar build/${PN}{,-viewer}.jar

	dodoc Readme
}
