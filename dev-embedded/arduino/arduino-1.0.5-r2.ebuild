# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="doc examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="https://arduino.cc/ https://github.com/arduino/"
SRC_URI="
	https://github.com/arduino/Arduino/archive/${PV}.tar.gz -> arduino-src-${PV}.tar.gz
	mirror://gentoo/arduino-icons.tar.bz2
"

LICENSE="GPL-2 GPL-2+ LGPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip binchecks"

S="${WORKDIR}/Arduino-${PV}"

CDEPEND="
	dev-java/jna:0
	>dev-java/rxtx-2.1:2"

RDEPEND="
	${CDEPEND}
	dev-embedded/avrdude
	dev-embedded/uisp
	sys-devel/crossdev
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

EANT_GENTOO_CLASSPATH="jna,rxtx-2"
EANT_EXTRA_ARGS="-Dversion=${PV}"
EANT_BUILD_TARGET="build"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	# Remove the libraries to ensure the system
	# libraries are used
	rm -rv \
		build/linux/dist/tools/avrdude* \
		build/linux/dist/lib/* \
		app/lib/* \
		app/src/processing/app/macosx || die
	# Patch build/build.xml - remove local jar files
	# for rxtx and ecj (use system wide versions)
	epatch \
		"${FILESDIR}"/${PN}-1.0.1-build.xml.patch \
		"${FILESDIR}"/${PN}-1.0.3-script.patch

	default
}

src_compile() {
	eant -f core/build.xml
	EANT_GENTOO_CLASSPATH_EXTRA="../core/core.jar"
	eant -f app/build.xml
	eant "${EANT_EXTRA_ARGS}" -f build/build.xml
}

src_install() {
	cd "${S}"/build/linux/work || die
	java-pkg_dojar lib/core.jar lib/pde.jar
	java-pkg_dolauncher ${PN} --pwd /usr/share/${PN} --main processing.app.Base

	if use examples; then
		java-pkg_doexamples examples
		docompress -x /usr/share/doc/${PF}/examples/
	fi

	if use doc; then
		DOCS=( revisions.txt "${S}"/readme.txt )
		HTML_DOCS=( reference )
		einstalldocs
		java-pkg_dojavadoc "${S}"/build/javadoc/everything
	fi

	insinto "/usr/share/${PN}/"
	doins -r hardware libraries
	fowners -R root:uucp "/usr/share/${PN}/hardware"

	insinto "/usr/share/${PN}/lib"
	doins -r lib/*.txt lib/theme lib/*.jpg

	# use system avrdude
	# patching class files is too hard
	dosym /usr/bin/avrdude "/usr/share/${PN}/hardware/tools/avrdude"
	dosym /etc/avrdude.conf "/usr/share/${PN}/hardware/tools/avrdude.conf"

	# install menu and icons
	domenu "${FILESDIR}/${PN}.desktop"
	for sz in 16 24 32 48 128 256; do
		newicon -s $sz \
			"${WORKDIR}/${PN}-icons/debian_icons_${sz}x${sz}_apps_${PN}.png" \
			"${PN}.png"
	done
}

pkg_postinst() {
	[[ ! -x /usr/bin/avr-g++ ]] && ewarn "Missing avr-g++; you need to crossdev -s4 avr"
}
