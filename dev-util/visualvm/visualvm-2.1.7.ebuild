# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NBV=140
NBT=20230511
NBZ=nb${NBV}_platform_${NBT}.zip
FLIGHT_RECORDER_VERSION="8.3.0"
FLIGHT_RECORDER_FILE="flightrecorder-${FLIGHT_RECORDER_VERSION}.jar"
COMMON_VERSION="8.3.0"
COMMON_FILE="common-${COMMON_VERSION}.jar"
ENCODER_VERSION="1.2.3"
ENCODER_FILE="encoder-${ENCODER_VERSION}.jar"
LZ4_JAVA_VERSION="1.8.0"
LZ4_JAVA_FILE="lz4-java-${LZ4_JAVA_VERSION}.jar"

inherit java-pkg-2 java-ant-2 desktop

DESCRIPTION="Integrates commandline JDK tools and profiling capabilities"
HOMEPAGE="https://visualvm.github.io"

SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/oracle/${PN}/releases/download/${PV}/${NBZ}
	https://repo1.maven.org/maven2/org/openjdk/jmc/flightrecorder/${FLIGHT_RECORDER_VERSION}/${FLIGHT_RECORDER_FILE}
	https://repo1.maven.org/maven2/org/openjdk/jmc/common/${COMMON_VERSION}/${COMMON_FILE}
	https://repo1.maven.org/maven2/org/owasp/encoder/encoder/${ENCODER_VERSION}/${ENCODER_FILE}"

LICENSE="GPL-2-with-linking-exception"
SLOT="7"
KEYWORDS="~amd64"

COMMON_DEPEND="
	dev-java/lz4-java:0
"

RDEPEND="
	${COMMON_DEPEND}
	dev-java/asm:9
	dev-java/hamcrest-core:1.3
	dev-java/jna:4
	dev-java/junit:4
	dev-java/junit:5
	dev-java/testng:0
	>=virtual/jre-1.8:*"

# it does not compile with java 11
DEPEND="
	${COMMON_DEPEND}
	virtual/jdk:1.8"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${P}/${PN}"

QA_PREBUILT="
	/usr/share/visualvm/cluster/lib/deployed/jdk15/linux-amd64/libprofilerinterface.so
	/usr/share/visualvm/cluster/lib/deployed/jdk16/linux-amd64/libprofilerinterface.so
	/usr/share/visualvm/platform/modules/lib/aarch64/linux/libjnidispatch-nb.so
	/usr/share/visualvm/platform/modules/lib/amd64/linux/libjnidispatch-nb.so
	/usr/share/visualvm/platform/modules/lib/riscv64/linux/libjnidispatch-nb.so
"

EANT_BUILD_TARGET=build
EANT_EXTRA_ARGS="-Dext.binaries.downloaded=true"
INSTALL_DIR=/usr/share/${PN}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}" || die
	unpack ${NBZ}
}

src_prepare() {
	default

	# Remove unneeded binaries
	rm -rv netbeans/platform/lib/*.{dll,exe} \
		netbeans/platform/modules/lib/{amd64/*.dll,i386,x86} || die
	find libs.profiler/lib.profiler/release/lib/deployed/jdk1? -mindepth 1 \
		-maxdepth 1 ! -name linux-amd64 -exec rm -rv {} + || die

	# link in downloaded jars
	for file in ${FLIGHT_RECORDER_FILE} ${COMMON_FILE} ${ENCODER_FILE}; do
		ln -s "${DISTDIR}/${file}" jfr.generic/external/ || die "Failed to link file ${file}"
	done

	java-pkg_jar-from --into jfr.generic/external lz4-java lz4-java.jar ${LZ4_JAVA_FILE} \
		|| die "Failed to link lz4 java jar"
}

src_install() {
	# this is the visualvm cluster
	insinto ${INSTALL_DIR}
	doins -r build/cluster netbeans/{harness,platform}

	# configuration file that can be used to tweak visualvm startup parameters
	insinto /etc/${PN}
	newins launcher/visualvm.conf ${PN}.conf
	sed -i "s%visualvm_default_userdir=.*%visualvm_default_userdir=\"\${HOME}/.visualvm\"%g" "${ED}/etc/${PN}/visualvm.conf" \
		|| die "Failed to update userdir"
	sed -i "s%visualvm_default_cachedir=.*%visualvm_default_cachedir=\"\${HOME}/.cache/visualvm\"%g" "${ED}/etc/${PN}/visualvm.conf" \
		|| die "Failed to update cachedir"
	echo -e "\nvisualvm_jdkhome=\"\$(java-config -O)\"" >> "${ED}/etc/${PN}/visualvm.conf" \
		|| die "Failed to set jdk detection"

	# replace bundled stuff
	pushd "${ED}/${INSTALL_DIR}/platform/core" > /dev/null || die
	for name in asm{,-commons,-tree}; do
		rm ${name}-9.2.jar && java-pkg_jar-from asm-9 ${name}.jar ${name}-9.2.jar || die
	done
	popd > /dev/null

	pushd "${ED}/${INSTALL_DIR}/platform/modules/ext" > /dev/null || die
	rm hamcrest-core-1.3.jar && java-pkg_jar-from hamcrest-core-1.3 hamcrest-core.jar hamcrest-core-1.3.jar || die
	rm jcommander-1.78.jar && java-pkg_jar-from jcommander jcommander.jar jcommander-1.78.jar || die
	for name in jna{,-platform}; do
		rm ${name}-5.12.1.jar && java-pkg_jar-from jna-4 ${name}.jar ${name}-5.12.1.jar || die
	done
	rm junit-4.13.2.jar && java-pkg_jar-from junit-4 junit.jar junit-4.13.2.jar || die
	for name in junit-jupiter-{api,engine,params}; do
		rm ${name}-5.6.0.jar && java-pkg_jar-from junit-5 ${name}.jar ${name}-5.6.0.jar || die
	done
	rm testng-6.14.3.jar && java-pkg_jar-from testng testng.jar testng-6.14.3.jar || die
	popd > /dev/null

	pushd "${ED}/${INSTALL_DIR}/cluster/modules/ext" > /dev/null || die
	rm ${LZ4_JAVA_FILE} && java-pkg_jar-from lz4-java lz4-java.jar ${LZ4_JAVA_FILE} || die
	popd > /dev/null

	# visualvm runtime script
	newbin "${FILESDIR}"/${PN}-r2.sh ${PN}

	# makes visualvm entry
	make_desktop_entry ${PN} VisualVM java "Development;Java;"
}
