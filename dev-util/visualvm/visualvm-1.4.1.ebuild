# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NBV=90
NBT=24042018
NBZ=nb${NBV}_${PN}_${NBT}.zip

inherit java-pkg-2 java-ant-2

DESCRIPTION="Integrates commandline JDK tools and profiling capabilities"
HOMEPAGE="https://visualvm.github.io"

# Netbeans plattform is already included in the main archive this time
#    SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
#       https://github.com/oracle/${PN}/releases/download/${PV}/${NBZ}"
SRC_URI="https://github.com/oracle/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="7"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.7"

DEPEND="
	>=virtual/jdk-1.7"

S="${WORKDIR}/${P}/${PN}"

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
	find netbeans/profiler/lib/deployed/jdk1? -mindepth 1 \
		-maxdepth 1 ! -name linux-amd64 -exec rm -rv {} + || die
}

src_install() {
	# this is the visualvm cluster
	insinto ${INSTALL_DIR}
	doins -r build/cluster netbeans/{platform,profiler}

	# configuration file that can be used to tweak visualvm startup parameters
	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}-r1.conf ${PN}.conf

	# visualvm runtime script
	newbin "${FILESDIR}"/${PN}-r1.sh ${PN}

	# makes visualvm entry
	make_desktop_entry ${PN} VisualVM java "Development;Java;"
}
