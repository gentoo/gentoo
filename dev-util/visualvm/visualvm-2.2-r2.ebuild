# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NBV=220
NBT=20250323
NBZ=nb${NBV}_platform_${NBT}.zip
FLIGHT_RECORDER_VERSION="8.3.1"
FLIGHT_RECORDER_FILE="flightrecorder-${FLIGHT_RECORDER_VERSION}.jar"
COMMON_VERSION="8.3.1"
COMMON_FILE="common-${COMMON_VERSION}.jar"
ENCODER_VERSION="1.2.3"
ENCODER_FILE="encoder-${ENCODER_VERSION}.jar"
JMC_SLOT="8.3.0"
LZ4_JAVA_VERSION="1.8.0"
LZ4_JAVA_FILE="lz4-java-${LZ4_JAVA_VERSION}.jar"
NASHORN_CORE_VERSION="15.4"
NASHORN_CORE_FILE="nashorn-core-${NASHORN_CORE_VERSION}.jar"

inherit java-pkg-2 desktop

DESCRIPTION="Integrates commandline JDK tools and profiling capabilities"
HOMEPAGE="https://visualvm.github.io"

SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/oracle/${PN}/releases/download/${PV}/${NBZ}
	https://repo1.maven.org/maven2/org/openjdk/nashorn/nashorn-core/${NASHORN_CORE_VERSION}/${NASHORN_CORE_FILE}"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="
	app-arch/unzip
	>=dev-java/ant-1.10.14-r3:0
"

# hamcrest-core, jcommander, jna, junit:4, junit:5 and testng are needed only on runtime.
# They are added here to get rid of a QA notice, #937128.
COMMON_DEPEND="
	dev-java/asm:0
	dev-java/hamcrest-core:1.3
	dev-java/jcommander:0
	dev-java/jmc:${JMC_SLOT}
	dev-java/jna:0
	dev-java/junit:4
	dev-java/junit:5
	dev-java/lz4-java:0
	dev-java/owasp-java-encoder:0
	dev-java/testng:0
"

# it does not compile with java 11
# not even after removing hardcoded -source and -target values
DEPEND="
	${COMMON_DEPEND}
	virtual/jdk:1.8
"

RDEPEND="
	${COMMON_DEPEND}
	!dev-util/visualvm:7
	>=virtual/jre-1.8:*
"

QA_PREBUILT="
	/usr/share/visualvm/cluster/lib/deployed/jdk15/linux-amd64/libprofilerinterface.so
	/usr/share/visualvm/cluster/lib/deployed/jdk16/linux-amd64/libprofilerinterface.so
	/usr/share/visualvm/platform/modules/lib/libflatlaf-linux-x86_64.so
	/usr/share/visualvm/platform/modules/lib/aarch64/linux/libjnidispatch-nb.so
	/usr/share/visualvm/platform/modules/lib/amd64/linux/libjnidispatch-nb.so
	/usr/share/visualvm/platform/modules/lib/riscv64/linux/libjnidispatch-nb.so
"

INSTALL_DIR=/usr/share/${PN}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}" || die
	unpack ${NBZ}
}

src_prepare() {
	java-pkg-2_src_prepare

	# Remove unneeded binaries
	rm -rv netbeans/platform/lib/*.{dll,exe} \
		netbeans/platform/modules/lib/{amd64/*.dll,i386,x86} || die
	find libs.profiler/lib.profiler/release/lib/deployed/jdk1? -mindepth 1 \
		-maxdepth 1 ! -name linux-amd64 -exec rm -rv {} + || die

	# link in external libraries
	ln -s "${DISTDIR}/${NASHORN_CORE_FILE}" nashorn.jdk15/external || die "Failed to link nashorn core jar"
	java-pkg_jar-from --into jfr.generic/external jmc-${JMC_SLOT} jmc-common.jar ${COMMON_FILE} \
		|| die "Failed to link jmc common jar"
	java-pkg_jar-from --into jfr.generic/external jmc-${JMC_SLOT} jmc-flightrecorder.jar ${FLIGHT_RECORDER_FILE} \
		|| die "Failed to link jmc flightrecorder jar"
	java-pkg_jar-from --into jfr.generic/external lz4-java lz4-java.jar ${LZ4_JAVA_FILE} \
		|| die "Failed to link lz4 java jar"
	java-pkg_jar-from --into jfr.generic/external owasp-java-encoder owasp-java-encoder.jar ${ENCODER_FILE} \
		|| die "Failed to link owasp-java-encoder jar"

	# remove hardcoded javac's source & target settings
	cd .. || die
	find -name build.xml \
		-exec sed -Ei 's,(source|target)="1.5",,g' {} + ||
		die "remove javac's source & target in build.xml files"

	cd .. || die
	find -name build.xml \
		-exec sed -Ei 's,(source|target)="1.4",,g' {} + ||
		die "remove javac's source & target in build.xml files"

	for prop in $(find -name project.properties); do
		sed -e '/javac.source=/d' -e '/javac.target/d' -i ${prop}
	done

	for impl in $(find -name build-impl.xml); do
		sed -e '/default.javac.source=/d' -e '/default.javac.target/d' -i ${mpl}
	done
}

src_compile() {
	eant -v \
		-Dext.binaries.downloaded=true \
		-Djavac.source="$(java-pkg_get-source)" \
		-Djavac.target="$(java-pkg_get-target)" \
		build
}

src_install() {
	# this is the visualvm cluster
	insinto ${INSTALL_DIR}
	doins -r build/cluster netbeans/{harness,platform}

	# configuration file that can be used to tweak visualvm startup parameters
	insinto /etc/${PN}
	newins launcher/visualvm.conf ${PN}.conf
	sed -i "s%visualvm_default_userdir=.*%visualvm_default_userdir=\"\${HOME}/.visualvm\"%g" \
		"${ED}/etc/${PN}/visualvm.conf" || die "Failed to update userdir"
	sed -i "s%visualvm_default_cachedir=.*%visualvm_default_cachedir=\"\${HOME}/.cache/visualvm\"%g" \
		"${ED}/etc/${PN}/visualvm.conf" || die "Failed to update cachedir"
	echo -e "\nvisualvm_jdkhome=\"\$(java-config -O)\"" >> "${ED}/etc/${PN}/visualvm.conf" \
		|| die "Failed to set jdk detection"

	# replace bundled stuff
	pushd "${ED}/${INSTALL_DIR}/platform/core" > /dev/null || die
	for name in asm{,-commons,-tree}; do
		rm ${name}-9.7.jar && java-pkg_jar-from asm ${name}.jar ${name}-9.7.jar || die
	done
	popd > /dev/null

	pushd "${ED}/${INSTALL_DIR}/platform/modules/ext" > /dev/null || die
	rm hamcrest-core-1.3.jar && java-pkg_jar-from hamcrest-core-1.3 hamcrest-core.jar hamcrest-core-1.3.jar || die
	rm jcommander-1.78.jar && java-pkg_jar-from jcommander jcommander.jar jcommander-1.78.jar || die
	for name in jna{,-platform}; do
		rm ${name}-5.14.0.jar && java-pkg_jar-from jna ${name}.jar ${name}-5.14.0.jar || die
	done
	rm junit-4.13.2.jar && java-pkg_jar-from junit-4 junit.jar junit-4.13.2.jar || die
	for name in junit-jupiter-{api,engine,params}; do
		rm ${name}-5.10.2.jar && java-pkg_jar-from junit-5 ${name}.jar ${name}-5.10.2.jar || die
	done
	rm testng-6.14.3.jar && java-pkg_jar-from testng testng.jar testng-6.14.3.jar || die
	popd > /dev/null

	pushd "${ED}/${INSTALL_DIR}/cluster/modules/ext" > /dev/null || die
	rm ${COMMON_FILE} && java-pkg_jar-from jmc-${JMC_SLOT} jmc-common.jar ${COMMON_FILE} || die
	rm ${FLIGHT_RECORDER_FILE} && java-pkg_jar-from jmc-${JMC_SLOT} jmc-flightrecorder.jar ${FLIGHT_RECORDER_FILE} || die
	rm ${LZ4_JAVA_FILE} && java-pkg_jar-from lz4-java lz4-java.jar ${LZ4_JAVA_FILE} || die
	rm ${ENCODER_FILE} && java-pkg_jar-from owasp-java-encoder owasp-java-encoder.jar ${ENCODER_FILE} || die
	popd > /dev/null

	# visualvm runtime script
	newbin "${FILESDIR}"/${PN}-r2.sh ${PN}

	# makes visualvm entry
	make_desktop_entry ${PN} VisualVM java "Development;Java;"
}
