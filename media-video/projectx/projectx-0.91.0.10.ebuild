# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils toolchain-funcs java-pkg-2 java-ant-2

XDG_P="xdg-20100731"

DESCRIPTION="Converts, splits and demuxes DVB and other MPEG recordings"
HOMEPAGE="http://project-x.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~billie/distfiles/${P}.tar.xz
	http://sbriesen.de/gentoo/distfiles/${PN}-idctfast.tar.xz
	http://sbriesen.de/gentoo/distfiles/${XDG_P}.java.xz
	http://sbriesen.de/gentoo/distfiles/${PN}-icon.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="X cpu_flags_x86_mmx cpu_flags_x86_sse"

COMMON_DEP="dev-java/commons-net
	X? ( =dev-java/browserlauncher2-1* )"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	app-arch/xz-utils
	virtual/libiconv
	${COMMON_DEP}"

S="${WORKDIR}/Project-X"

mainclass() {
	# read Main-Class from MANIFEST.MF
	sed -n "s/^Main-Class: \([^ ]\+\).*/\1/p" "${S}/MANIFEST.MF" || die
}

java_prepare() {
	local X

	# apply stdout corruption patch (zzam@gentoo.org)
	epatch "${FILESDIR}/${PN}-0.90.4.00_p33-stdout-corrupt.patch"

	# apply BrowserLauncher2 patch
	use X && epatch "${FILESDIR}/${PN}-0.90.4.00_p33-bl2.patch"
	rm -rf src/edu || die

	# apply IDCTFast patch
	epatch "${FILESDIR}/${PN}-0.90.4.00_p33-idctfast.patch"

	# apply XDG patch
	cp -f "${WORKDIR}/${XDG_P}.java" "${S}/src/xdg.java" || die
	epatch "${FILESDIR}/${PN}-0.90.4.00_p33-xdg.patch"

	# copy build.xml
	cp -f "${FILESDIR}/build-0.90.4.00_p33.xml" build.xml || die

	# patch executable and icon
	sed -i -e "s:^\(Exec=\).*:\1${PN}_gui:g" \
		-e "s:^\(Icon=\).*:\1${PN}:g" *.desktop || die

	# convert CRLF to LF
	edos2unix *.txt MANIFEST.MF

	# convert docs to utf-8
	if [ -x "$(type -p iconv)" ]; then
		for X in zutun.txt; do
			iconv -f LATIN1 -t UTF8 -o "${X}~" "${X}" && mv -f "${X}~" "${X}" || die
		done
	fi

	# merge/remove resources depending on USE="X"
	if use X; then
		mv -f htmls resources/ || die
	else
		rm -rf src/net/sourceforge/dvb/projectx/gui || die
		rm resources/*.gif || die
	fi

	# update library packages
	cd lib || die
	rm -f {commons-net,jakarta-oro}*.jar || die
	java-pkg_jar-from commons-net
	use X && java-pkg_jar-from browserlauncher2-1.0
	java-pkg_ensure-no-bundled-jars
}

src_compile() {
	local IDCT="idct-mjpeg"  # default IDCT implementation
	if use x86 || use amd64; then
		use cpu_flags_x86_mmx && IDCT="idct-mjpeg-mmx"
		use cpu_flags_x86_sse && IDCT="idct-mjpeg-sse"
	fi

	eant build $(use_doc) -Dmanifest.mainclass=$(mainclass)

	cd lib/PORTABLE || die
	emake CC=$(tc-getCC) IDCT="${IDCT}" LDFLAGS="${LDFLAGS}" \
		CPLAT="${CFLAGS} -O3 -ffast-math -fPIC"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_doso lib/PORTABLE/libidctfast.so

	java-pkg_dolauncher ${PN}_cli --main $(mainclass) \
		--java_args "-Djava.awt.headless=true -Xmx256m"

	if use X; then
		java-pkg_dolauncher ${PN}_gui --main $(mainclass) \
			--java_args "-Xmx256m"
		dosym ${PN}_gui /usr/bin/${PN}
		newicon "${DISTDIR}/${PN}-icon.png" "${PN}.png"
		domenu *.desktop
	else
		dosym ${PN}_cli /usr/bin/${PN}
	fi

	dodoc *.txt
	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src
}
