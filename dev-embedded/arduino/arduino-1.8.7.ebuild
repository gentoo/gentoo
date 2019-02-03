# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 gnome2-utils

DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="https://arduino.cc/ https://github.com/arduino/"

ARDUINO_DOCS=(
	"reference-1.6.6-3"
	"Galileo_help_files-1.6.2"
	"Edison_help_files-1.6.2"
)

for docname in "${ARDUINO_DOCS[@]}"; do
	ARDUINO_DOCS_URI+=" https://downloads.arduino.cc/${docname}.zip -> ${PN}-${docname}.zip"
done

SRC_URI="https://github.com/arduino/Arduino/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://downloads.arduino.cc/cores/avr-1.6.23.tar.bz2 -> ${PN}-avr-1.6.23.tar.bz2
	https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.9.2/WiFi101-Updater-ArduinoIDE-Plugin-0.9.2.zip -> ${PN}-WiFi101-Updater-ArduinoIDE-Plugin-0.9.2.zip
	doc? (
		${ARDUINO_DOCS_URI}
	)"

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

CDEPEND="dev-embedded/arduino-builder"

RDEPEND="${CDEPEND}
	>=dev-util/astyle-3.1[java]
	dev-embedded/arduino-listserialportsc
	>=virtual/jre-1.8"

DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.8"

EANT_BUILD_TARGET="build"
# don't run the default "javadoc" target, we don't have one.
EANT_DOC_TARGET=""
EANT_BUILD_XML="build/build.xml"
EANT_EXTRA_ARGS=" -Dlight_bundle=1 -Dlocal_sources=1 -Dno_arduino_builder=1"

RESTRICT="strip"
QA_PREBUILT="usr/share/arduino/hardware/arduino/avr/firmwares/*"

S="${WORKDIR}/Arduino-${PV}"

PATCHES=(
	# We need to load system astyle/listserialportsc instead of bundled ones.
	"${FILESDIR}/${PN}-1.8.5-lib-loading.patch"
)

src_unpack() {
	# We don't want to unpack tools, just move zip files into the work dir
	unpack `echo ${A} | cut -d ' ' -f1`

	cp "${DISTDIR}/${PN}-avr-1.6.23.tar.bz2" "${S}/build/avr-1.6.23.tar.bz2" || die
	cp "${DISTDIR}/${PN}-WiFi101-Updater-ArduinoIDE-Plugin-0.9.2.zip" "${S}/build/shared/WiFi101-Updater-ArduinoIDE-Plugin-0.9.2.zip"|| die

	if use doc; then
		local docname
		for docname in "${ARDUINO_DOCS[@]}"; do
			cp "${DISTDIR}/${PN}-${docname}.zip" "${S}/build/shared/${docname}.zip" || die
		done
	fi
}

src_prepare() {
	default

	# Unbundle libastyle
	sed -i 's/\(target name="linux-libastyle-[a-zA-Z0-9]*"\)/\1 if="never"/g' "$S/build/build.xml" || die

	# Unbundle avr toolchain
	sed -i 's/target name="avr-toolchain-bundle" unless="light_bundle"/target name="avr-toolchain-bundle" if="never"/' "$S/build/build.xml" || die

	# Install avr hardware
	sed -i 's/target name="assemble-hardware" unless="light_bundle"/target name="assemble-hardware"/' "$S/build/build.xml" || die
}

src_compile() {
	if ! use doc; then
		EANT_EXTRA_ARGS+=" -Dno_docs=1"
	fi
	java-pkg-2_src_compile
}

src_install() {
	cd "${S}"/build/linux/work || die

	# We need to replace relative paths for toolchain executable by paths to system ones.
	sed -i -e 's@^compiler.path=.*@compiler.path=/usr/bin/@' -e 's@^tools.avrdude.path=.*@tools.avrdude.path=/usr@' \
		-e 's@^tools.avrdude.config.path=.*@tools.avrdude.config.path=/etc/avrdude.conf@' hardware/arduino/avr/platform.txt || die

	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PN} \
		--pwd "/usr/share/${PN}" \
		--main "processing.app.Base" \
		--java_args "-DAPP_DIR=/usr/share/${PN} -Djava.library.path=${EPREFIX}/usr/$(get_libdir)"

	insinto "/usr/share/${PN}"

	doins -r examples hardware lib tools

	# In upstream's build process, we copy these fiels below from the bundled arduino-builder.
	# Here we do the same thing, but from the system arduino-builder.
	dosym "${EPREFIX}/usr/share/arduino-builder/platform.txt" "/usr/share/${PN}/hardware/platform.txt"
	dosym "${EPREFIX}/usr/share/arduino-builder/platform.keys.rewrite.txt" "/usr/share/${PN}/hardware/platform.keys.rewrite.txt"
	dosym "${EPREFIX}/usr/bin/arduino-builder" "/usr/share/${PN}/arduino-builder"

	# hardware/tools/avr needs to exist or arduino-builder will
	# complain about missing required -tools arg
	dodir "/usr/share/${PN}/hardware/tools/avr"

	if use doc; then
		HTML_DOCS=( reference )
		einstalldocs

		# arduino expects its doc in its "main" directory. symlink it.
		dosym "${EPREFIX}/usr/share/doc/${PF}/html/reference" "/usr/share/${PN}/reference"
	fi

	# Install menu and icons
	domenu "${FILESDIR}/${PN}.desktop"
	cd lib/icons || die
	local icondir
	for icondir in *; do
		# icondir name is something like "24x24" we want the "24" part
		local iconsize=`cut -dx -f1 <<< "${icondir}"`
		newicon -s $iconsize \
			"${icondir}/apps/arduino.png" \
			"${PN}.png"
	done
}

pkg_postinst() {
	gnome2_icon_cache_update
	[[ ! -x /usr/bin/avr-g++ ]] && ewarn "Missing avr-g++; you need to crossdev -s4 avr"
}
