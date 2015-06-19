# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ace/ace-5.5-r1.ebuild,v 1.13 2013/02/24 13:25:23 ulm Exp $

inherit eutils multilib toolchain-funcs

S="${WORKDIR}/ACE_wrappers"
DESCRIPTION="The Adaptive Communications Environment"
SRC_URI="!tao? ( http://deuce.doc.wustl.edu/old_distribution/ACE-${PV}.tar.bz2 )
		tao? ( http://deuce.doc.wustl.edu/old_distribution/ACE-${PV}+TAO-1.5.tar.bz2 )"

HOMEPAGE="http://www.cs.wustl.edu/~schmidt/ACE.html"

LICENSE="ACE BSD BSD-4 BSD-2 tao? ( sun-iiop RSA )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X ipv6 tao"

DEPEND="dev-libs/openssl"

RDEPEND="${DEPEND}
	X? ( x11-libs/libXt x11-libs/libXaw )"

DEPEND="${DEPEND}
	X? ( x11-proto/xproto )"

src_compile() {
	export ACE_ROOT="${S}"
	mkdir build
	cd build

	export ace_cv_new_throws_bad_alloc_exception="yes"

	ECONF_SOURCE=${S}
	econf --enable-lib-all $(use_with X) $(use_enable ipv6) $(use_with tao) || \
		die "econf died"
	# --with-qos needs ACE_HAS_RAPI
	emake static_libs=1 || die
}

src_test() {
	cd "${S}"/build
	make ACE_ROOT="${S}" check || die "self test failed"
	#einfo "src_test currently stalls after Process_Mutex_Test"
}

src_install() {
	cd build
	make ACE_ROOT="${S}" DESTDIR="${D}" install || die "failed to install"
	sed -i -e "^#define PACKAGE_.*//g" /usr/include/ace/config.h
	# punt gperf stuff
	rm -rf "${D}"/usr/bin/gperf "${D}"/usr/share
}

pkg_postinst() {
	# This is required, as anything trying to compile against ACE will have
	# problems with conflicting OS.h files if this is not done.

	local CC_MACHINE=`gcc -dumpmachine`
	local CC_VERSION=`gcc -dumpversion`
	if [ -d "/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" ]; then
	ewarn "moving /usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/$(gcc-fullversion)/include/ace to"
	ewarn "ace.old"
	ewarn "This is required, as anything trying to compile against ACE will"
	ewarn "have problems with conflicting OS.h files if this is not done."
		mv "/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" \
			"/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace.old"
	fi
}
