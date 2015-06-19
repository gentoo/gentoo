# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jss/jss-4.2.5.ebuild,v 1.3 2012/05/03 07:42:50 jdhore Exp $

inherit base java-pkg-2 versionator

RTM_NAME="JSS_${PV//./_}_RTM"
DESCRIPTION="Network Security Services for Java (JSS)"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/jss/"
# To prepare this tarball
# cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export \
#    -r JSS_4_2_RTM mozilla/security/corefonf
# cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export \
#    -r JSS_4_2_RTM mozilla/security/jss
# tar cvjf jss-4.2.tar.bz2 mozilla
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="3.4"
KEYWORDS="amd64 x86"
IUSE="doc examples source"

RDEPEND=">=virtual/jre-1.4
		>=dev-libs/nspr-4.3
		>=dev-libs/nss-3.9.2"
DEPEND=">=virtual/jdk-1.4
		${RDEPEND}
		app-arch/zip
		virtual/pkgconfig
		>=sys-apps/sed-4"

S=${WORKDIR}/mozilla

PATCHES=(
	"${FILESDIR}/${PN}-3.4-target_source.patch"
	"${FILESDIR}/${PN}-4.2.5-use_pkg-config.patch"
)

src_compile() {
	export JAVA_GENTOO_OPTS="-target $(java-pkg_get-target) -source $(java-pkg_get-source)"
	use amd64 && export USE_64=1
	cd "${S}/security/coreconf" || die
	emake -j1 BUILD_OPT=1 || die "coreconf make failed"

	cd "${S}/security/jss" || die
	emake -j1 BUILD_OPT=1 USE_PKGCONFIG=1 NSS_PKGCONFIG=nss NSPR_PKGCONFIG=nspr || die "jss make failed"
	if use doc; then
		emake -j1 BUILD_OPT=1 javadoc || die "failed to create javadocs"
	fi
}

# Investigate why this fails
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
