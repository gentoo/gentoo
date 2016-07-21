# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic java-pkg-2 java-ant-2 multilib
EANT_BUILD_TARGET=${PN}

DESCRIPTION="Java library for rendering PDF, XPS and CBZ (Comic Book) documents"
HOMEPAGE="https://code.google.com/p/jmupdf/"
SRC_URI="https://jmupdf.googlecode.com/files/2012-02-23-source-${P}.7z"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="system-mupdf"

REQUIRED_USE="!system-mupdf"

RDEPEND="
	media-libs/freetype:2
	media-libs/openjpeg:0=
	system-mupdf? ( >=app-text/mupdf-1.2 )
	virtual/jdk:1.7
"
DEPEND="${RDEPEND}
	app-arch/p7zip
	media-libs/libbmp
"

S=${WORKDIR}/${PN}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build-xml.patch \
		"${FILESDIR}"/${P}-umlaut.patch

	edos2unix ../mupdf/jni/*

	sed -e "/^JVM_INCLUDES/s:=.*:= $(java-pkg_get-jni-cflags):" \
		-i ../mupdf/MakeJNI2 || die
	sed -e "s:-pipe -O2::" \
		-i ../mupdf/Makerules || die

	rm -r ../mupdf/thirdparty || die
	if use system-mupdf ; then
		for i in android apps cbz cmaps debian draw fitz fonts ios pdf scripts viewer win32 xps ; do
			einfo remove mupdf/${i}
			rm -r ../mupdf/${i} || die
		done
	fi
}

src_compile() {
	local system-fitz=$(usex system-mupdf "FITZ_LIB=\"${EROOT}usr/$(get_libdir)/libfitz.so\"" "" )
	emake -C ../mupdf \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		SYS_FREETYPE_INC="$($(tc-getPKG_CONFIG) --cflags freetype2)" \
		"${system-fitz}" \
		JNI_DLL=build/libjmupdf.so \
		JNI_CMD="-shared -Wl,-soname -Wl,lib${PN}.so" \
		build/libjmupdf.so

	java-pkg-2_src_compile
}

src_install() {
	dolib.so ../mupdf/build/lib${PN}.so

	java-pkg_dojar build/${PN}{,-viewer}.jar

	dodoc Readme
}
