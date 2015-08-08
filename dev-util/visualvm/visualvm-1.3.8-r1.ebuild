# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Integrates commandline JDK tools and profiling capabilites"
HOMEPAGE="http://visualvm.java.net/"
SRC_URI="https://java.net/downloads/visualvm/release138/visualvm_138-src.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="7"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="
	|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
	dev-java/netbeans-platform:8.0
	dev-java/netbeans-profiler:8.0"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	dev-java/netbeans-harness:8.0"

S="${WORKDIR}/visualvm"
INSTALL_DIR=/usr/share/${PN}

EANT_BUILD_TARGET="build"

src_prepare() {
	mkdir "${S}/netbeans" || die "Failed to create netbeans directory"
	ln -s /usr/share/netbeans-harness-8.0 "${S}/netbeans/harness" || die "Failed to symlink harness"
	ln -s /usr/share/netbeans-platform-8.0 "${S}/netbeans/platform" || die "Failed to symlink platform"
	ln -s /usr/share/netbeans-profiler-8.0 "${S}/netbeans/profiler" || die "Failed to symlink profiler"
}

src_install() {
	# this is the visualvm cluster
	insinto ${INSTALL_DIR}
	doins -r "${S}/build/cluster"

	# these are netbeans platform configuration files that prevent display of missing modules during startup
	insinto ${INSTALL_DIR}/config
	doins "${FILESDIR}"/org-netbeans-modules-profiler-*.xml

	# configuration file that can be used to tweak visualvm startup parameters
	insinto /etc/visualvm
	doins "${FILESDIR}/visualvm.conf"

	# visualvm runtime script
	into ${INSTALL_DIR}
	dobin "${FILESDIR}/visualvm.sh"
	fperms 755 ${INSTALL_DIR}/bin/visualvm.sh
	dosym ${INSTALL_DIR}/bin/visualvm.sh /usr/bin/visualvm

	# makes visualvm entry
	make_desktop_entry "/usr/bin/visualvm" "VisualVM" "java" "Development;Java;"
}
