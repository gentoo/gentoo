# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NBV=124
NBT=21062021
NBZ=nb${NBV}_platform_${NBT}.zip

inherit java-pkg-2 java-ant-2 desktop

DESCRIPTION="Integrates commandline JDK tools and profiling capabilities"
HOMEPAGE="https://visualvm.github.io"

# Netbeans plattform is already included in the main archive this time
#    SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
#       https://github.com/oracle/${PN}/releases/download/${PV}/${NBZ}"
SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="7"
KEYWORDS="amd64"

RDEPEND="
	>=virtual/jre-1.8:*"

# it does not compile with java 11
DEPEND="
	virtual/jdk:1.8"

S="${WORKDIR}/${P}/${PN}"

QA_PREBUILT="
	/usr/share/visualvm/platform/modules/lib/amd64/linux/libjnidispatch-nb.so
	/usr/share/visualvm/cluster/lib/deployed/jdk1[56]/linux-amd64/libprofilerinterface.so
"

EANT_BUILD_TARGET=build
INSTALL_DIR=/usr/share/${PN}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}" || die
	# unpack ${NBZ}
	unpack "${S}"/"${NBZ}"  # archive is included in the main archive
}

src_prepare() {
	default

	# Remove unneeded binaries
	rm -rv netbeans/platform/lib/*.{dll,exe} \
		netbeans/platform/modules/lib/{amd64/*.dll,i386,x86} || die
	find libs.profiler/lib.profiler/release/lib/deployed/jdk1? -mindepth 1 \
		-maxdepth 1 ! -name linux-amd64 -exec rm -rv {} + || die
}

src_install() {
	# this is the visualvm cluster
	insinto ${INSTALL_DIR}
	doins -r build/cluster netbeans/{harness,platform}

	# configuration file that can be used to tweak visualvm startup parameters
	insinto /etc/${PN}
	newins launcher/visualvm.conf ${PN}.conf
	sed -i "s%visualvm_default_userdir=.*%visualvm_default_userdir=\"\${HOME}/.visualvm\"%g" "${ED}/etc/${PN}/visualvm.conf" || die "Failed to update userdir"
	sed -i "s%visualvm_default_cachedir=.*%visualvm_default_cachedir=\"\${HOME}/.cache/visualvm\"%g" "${ED}/etc/${PN}/visualvm.conf" || die "Failed to update cachedir"
	echo -e "\nvisualvm_jdkhome=\"\$(java-config -O)\"" >> "${ED}/etc/${PN}/visualvm.conf" || die "Failed to set jdk detection"

	# visualvm runtime script
	newbin "${FILESDIR}"/${PN}-r2.sh ${PN}

	# makes visualvm entry
	make_desktop_entry ${PN} VisualVM java "Development;Java;"
}
