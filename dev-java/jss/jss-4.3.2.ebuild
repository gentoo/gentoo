# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit multilib toolchain-funcs java-pkg-2

DESCRIPTION="Network Security Services for Java (JSS)"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/JSS"
# 4.3.2 was released but was seemingly never announced. The binary jar
# exists on Mozilla's servers but Chewi could only find a source tarball
# at https://obs.kolabsys.com/package/show/Kolab:3.4/jss. However, you
# need to register in order to download it, hence he has mirrored it.
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${P}.tar.bz2"
LICENSE="MPL-1.1"
SLOT="3.4"
KEYWORDS="amd64 ~x86"
IUSE="examples test"

CDEPEND=">=dev-libs/nspr-4.7.1
	>=dev-libs/nss-3.12.5"

DEPEND="${CDEPEND}
	dev-lang/perl
	>=virtual/jdk-1.6
	virtual/pkgconfig
	test? ( dev-libs/nss[utils] )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}/mozilla"

java_prepare() {
	epatch "${FILESDIR}"/${PN}-3.4-target_source.patch
	epatch "${FILESDIR}"/${PN}-4.2.5-use_pkg-config.patch
	epatch "${FILESDIR}"/${PN}-4.3-cflags.patch
	epatch "${FILESDIR}"/${PN}-4.3.2-ldflags.patch
	epatch "${FILESDIR}"/${PN}-4.3-secitem.patch

	if java-pkg_is-vm-version-ge 1.8; then
		epatch "${FILESDIR}"/${PN}-4.3-javadoc.patch
	fi
}

src_compile() {
	local ARGS=(
		"CC=$(tc-getCC)"
		"AR=$(tc-getAR) cr \$@"
		"OS_RELEASE=2.6"
		"BUILD_OPT=1"
	)

	export JAVA_GENTOO_OPTS="$(java-pkg_javac-args)"
	use amd64 && export USE_64=1

	cd "${S}/security/coreconf" || die
	emake -j1 "${ARGS[@]}"

	cd "${S}/security/jss" || die
	emake -j1 "${ARGS[@]}" USE_PKGCONFIG=1 NSS_PKGCONFIG=nss NSPR_PKGCONFIG=nspr
	use doc && emake -j1 "${ARGS[@]}" javadoc
}

# Chewi has managed to reach a test pass rate of 31/40 (78%) but the
# remainder fail due to JSS not having kept pace with the ciphersuites
# in NSS. There's not much we can do about that. The suite also leaves
# java processes running and exits successfully on failure.
RESTRICT="test"

src_test() {
	# Parts of NSS are required for the tests.
	ln -snf "${EROOT}usr/$(get_libdir)/libnssckbi.so" dist/Linux*.OBJ/lib/ || die
	ln -snf "${EROOT}usr/bin" dist/Linux*.OBJ/ || die

	# The tests must be run from this directory.
	cd security/jss/org/mozilla/jss/tests || die
	BUILD_OPT=1 perl all.pl dist "${S}"/dist/Linux*.OBJ/ || die "tests failed"
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
