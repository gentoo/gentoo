# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jss/jss-4.3-r1.ebuild,v 1.4 2015/05/23 21:40:39 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit base java-pkg-2 linux-info versionator

RTM_NAME="JSS_${PV//./_}_RTM"

DESCRIPTION="Network Security Services for Java (JSS)"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/jss/"
# To prepare this tarball
# cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export \
#    -r JSS_4_3_RTM mozilla/security/coreconf
# cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export \
#    -r JSS_4_3_RTM mozilla/security/jss
# tar cvjf jss-4.3.tar.bz2 mozilla
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="3.4"
KEYWORDS="~amd64 ~x86"

CDEPEND=">=dev-libs/nspr-4.7
	>=dev-libs/nss-3.12"

DEPEND=">=virtual/jdk-1.4
	app-arch/zip
	virtual/pkgconfig
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

S="${WORKDIR}/mozilla"

java_prepare() {
	epatch "${FILESDIR}"/${PN}-3.4-target_source.patch
	epatch "${FILESDIR}"/${PN}-4.2.5-use_pkg-config.patch
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-secitem.patch
}

# See bug 539100.
pkg_setup() {
	linux-info_pkg_setup
	java-pkg-2_pkg_setup
}

src_compile() {
	export JAVA_GENTOO_OPTS="-source $(java-pkg_get-source) -target $(java-pkg_get-target)"

	use amd64 && export USE_64=1

	cd "${S}/security/coreconf" || die

	# Hotfix for kernel 3.x #379283
	get_running_version || die "Failed to determine kernel version"
	if [[ ${KV_MAJOR} -ge 3 ]]; then
		cp Linux2.6.mk Linux${KV_MAJOR}.${KV_MINOR}.mk || die
	fi

	emake -j1 BUILD_OPT=1

	cd "${S}/security/jss" || die
	emake -j1 BUILD_OPT=1 USE_PKGCONFIG=1 NSS_PKGCONFIG=nss NSPR_PKGCONFIG=nspr

	if use doc; then
		emake -j1 BUILD_OPT=1 javadoc
	fi
}

# Investigate why this fails.
#
# cp: cannot stat ‘/var/tmp/portage/dev-java/jss-4.3-r1/work/mozilla/dist/Linux3.8_x86_64_glibc_PTH_64_OPT.OBJ//lib/*nssckbi*’: No such file or directory
# Failed to copy builtins library at security/jss/org/mozilla/jss/tests/all.pl line 453.
#
# There is indeed no nssckbi file, investigation needed if that file can be
# generated or whether we can remove the broken test; possibly inform upstream.
RESTRICT="test"

src_test() {
	BUILD_OPT=1 perl security/jss/org/mozilla/jss/tests/all.pl dist \
		"${S}"/dist/Linux*.OBJ/
}

src_install() {
	java-pkg_dojar dist/*.jar

	# Use this instead of the one in dist because it is a symlink
	# and doso handles symlinks by just symlinking to the original
	java-pkg_doso ./security/${PN}/lib/*/*.so

	use doc && java-pkg_dojavadoc dist/jssdoc
	use source && java-pkg_dosrc ./security/jss/org
	use examples && java-pkg_doexamples ./security/jss/samples
}
