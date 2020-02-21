# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 gnome2-utils

DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="https://arduino.cc/ https://github.com/arduino/"

ARDUINO_LIBRARIES=(
	"Firmata 2.5.6"
	"Bridge 1.6.3"
	"Robot_Control 1.0.4"
	"Robot_Motor 1.0.3"
	"RobotIRremote 2.0.0"
	"SpacebrewYun 1.0.1"
	"Temboo 1.2.1"
	"Esplora 1.0.4"
	"Mouse 1.0.1"
	"Keyboard 1.0.1"
	"SD 1.1.1"
	"Servo 1.1.2"
	"LiquidCrystal 1.0.7"
	"Adafruit_CircuitPlayground 1.6.8 https://github.com/Adafruit/Adafruit_CircuitPlayground/archive/1.6.8.zip"
	"WiFi101-Updater-ArduinoIDE-Plugin 0.9.1 https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.9.1/WiFi101-Updater-ArduinoIDE-Plugin-0.9.1.zip build/shared/"
)

for lib in "${ARDUINO_LIBRARIES[@]}"; do
	lib=( $lib )
	default_url="https://github.com/arduino-libraries/${lib[0]}/archive/${lib[1]}.zip"
	url=${lib[2]:-$default_url}
	ARDUINO_LIBRARIES_URI+=" ${url} -> ${P}-${lib[0]}-${lib[1]}.zip"
done

ARDUINO_DOCS=(
	"reference-1.6.6-3"
	"Galileo_help_files-1.6.2"
	"Edison_help_files-1.6.2"
)

for docname in "${ARDUINO_DOCS[@]}"; do
	ARDUINO_DOCS_URI+=" https://downloads.arduino.cc/${docname}.zip -> ${P}-${docname}.zip"
done

SRC_URI="https://github.com/arduino/Arduino/archive/${PV}.tar.gz -> ${P}.tar.gz
	${ARDUINO_LIBRARIES_URI}
	doc? (
		${ARDUINO_DOCS_URI}
	)"

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

# bincheck RESTRICT is needed because firmware that ships with arduino contains code that makes
# scanelf bark. It's also why we need a separate package for arduino-listserialportsc because if
# we install it in the context of this package, we will get QA notices telling us we're doing a
# bad thing.
RESTRICT="strip"
QA_PREBUILT="usr/share/arduino/hardware/arduino/avr/firmwares/*
	usr/share/arduino/libraries/WiFi/extras/*"
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
EANT_EXTRA_ARGS="-Dno_arduino_builder=1 -Dlocal_sources=1"

S="${WORKDIR}/Arduino-${PV}"
SHARE="/usr/share/${PN}"

src_unpack() {
	# We don't want to unpack libraries, just move zip files into the work dir
	unpack `echo ${A} | cut -d ' ' -f1`
	local lib
	for lib in "${ARDUINO_LIBRARIES[@]}"; do
		lib=( $lib )
		local destfolder=${lib[3]:-build/}
		cp "${DISTDIR}/${P}-${lib[0]}-${lib[1]}.zip" "${S}/${destfolder}/${lib[0]}-${lib[1]}.zip" || die
	done
	if use doc; then
		local docname
		for docname in "${ARDUINO_DOCS[@]}"; do
			cp "${DISTDIR}/${P}-${docname}.zip" "${S}/build/shared/${docname}.zip" || die
		done
	fi
}

src_prepare() {
	# We need to disable astyle/listserialportsc and toolchain (avr-gcc, avrdude) bundling.
	eapply "${FILESDIR}/${PN}-1.8.5-build.xml.patch"

	# We need to replace relative paths for toolchain executable by paths to system ones.
	eapply "${FILESDIR}/${PN}-1.8.5-avr-platform.txt.patch"

	# We need to load system astyle/listserialportsc instead of bundled ones.
	eapply "${FILESDIR}/${PN}-1.8.5-lib-loading.patch"
	default
}

src_compile() {
	if ! use doc; then
		EANT_EXTRA_ARGS+=" -Dno_docs=1"
	fi
	java-pkg-2_src_compile
}

src_install() {
	cd "${S}"/build/linux/work || die

	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PN} \
		--pwd "${SHARE}" \
		--main "processing.app.Base" \
		--java_args "-DAPP_DIR=${SHARE} -Djava.library.path=${EPREFIX}/usr/$(get_libdir)"

	# Install libraries
	insinto "${SHARE}"

	doins -r examples hardware lib libraries tools

	# In upstream's build process, we copy these fiels below from the bundled arduino-builder.
	# Here we do the same thing, but from the system arduino-builder.
	dosym "../../arduino-builder/platform.txt" "${SHARE}/hardware/platform.txt"
	dosym "../../arduino-builder/platform.keys.rewrite.txt" "${SHARE}/hardware/platform.keys.rewrite.txt"
	dosym "../../../bin/arduino-builder" "${SHARE}/arduino-builder"

	# hardware/tools/avr needs to exist or arduino-builder will
	# complain about missing required -tools arg
	dodir "${SHARE}/hardware/tools/avr"

	if use doc; then
		HTML_DOCS=( reference )
		einstalldocs

		# arduino expects its doc in its "main" directory. symlink it.
		dosym "../doc/${PF}/html/reference" "${SHARE}/reference"
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
