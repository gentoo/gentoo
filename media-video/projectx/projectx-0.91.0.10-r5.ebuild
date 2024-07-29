# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit desktop java-pkg-2 java-pkg-simple toolchain-funcs xdg

XDG_P="xdg-20100731"

DESCRIPTION="Converts, splits and demuxes DVB and other MPEG recordings"
HOMEPAGE="https://project-x.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~billie/distfiles/${P}-r4.tar.xz
	https://dev.gentoo.org/~billie/distfiles/${PN}-idctfast.tar.xz
	https://dev.gentoo.org/~billie/distfiles/${XDG_P}.java.xz
	https://dev.gentoo.org/~billie/distfiles/${PN}-icon.png"

S="${WORKDIR}/Project-X"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="X cpu_flags_x86_mmx cpu_flags_x86_sse"

COMMON_DEPEND="
	dev-java/commons-net:0
	X? ( dev-java/browserlauncher2:1.0 )
"
RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"
DEPEND="
	${COMMON_DEPEND}
	>=virtual/jdk-1.8:*
	app-arch/xz-utils
"

JAVA_ENCODING="iso-8859-1"
JAVA_GENTOO_CLASSPATH="commons-net"
JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src"

src_prepare() {
	default

	xdg_environment_reset

	local X

	# apply stdout corruption patch (zzam@gentoo.org)
	eapply "${FILESDIR}/${PN}-0.91.0.10-stdout-corrupt.patch"

	# apply BrowserLauncher2 patch
	if use X; then
		eapply "${FILESDIR}/${PN}-0.91.0.10-bl2.patch"
		JAVA_GENTOO_CLASSPATH+=" browserlauncher2-1.0"
	fi
	rm -rf src/edu || die

	# apply IDCTFast patch
	eapply "${FILESDIR}/${PN}-0.91.0.10-idctfast.patch"

	# apply XDG patch
	cp -f "${WORKDIR}/${XDG_P}.java" "${S}/src/xdg.java" || die
	eapply "${FILESDIR}/${PN}-0.91.0.10-xdg.patch"

	# patch executable and icon
	sed -i -e "s:^\(Exec=\).*:\1${PN}_gui:g" \
		-e "s:^\(Icon=\).*:\1${PN}:g" *.desktop || die

	JAVA_MAIN_CLASS="$(grep Main MANIFEST.MF | cut -d' ' -f2)"

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

	java-pkg-simple_src_compile

	cd lib/PORTABLE || die
	emake CC="$(tc-getCC)" IDCT="${IDCT}" LDFLAGS="${LDFLAGS}" \
		CPLAT="${CFLAGS} -O3 -ffast-math -fPIC"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso lib/PORTABLE/libidctfast.so

	java-pkg_dolauncher ${PN}_cli --main ${JAVA_MAIN_CLASS} \
		--java_args "-Djava.awt.headless=true -Xmx256m"

	if use X; then
		java-pkg_dolauncher ${PN}_gui --main ${JAVA_MAIN_CLASS} \
			--java_args "-Xmx256m"
		dosym ${PN}_gui /usr/bin/${PN}
		newicon "${DISTDIR}/${PN}-icon.png" "${PN}.png"
		domenu *.desktop
	else
		dosym ${PN}_cli /usr/bin/${PN}
	fi

	dodoc *.txt
}
