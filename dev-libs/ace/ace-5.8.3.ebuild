# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="The Adaptive Communications Environment"
HOMEPAGE="http://www.dre.vanderbilt.edu/~schmidt/ACE.html"
SRC_URI="!tao? ( http://download.dre.vanderbilt.edu/previous_versions/ACE-${PV}.tar.bz2 )
	tao? (
		!ciao? ( http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO-${PV}.tar.bz2 )
		ciao? ( http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO+CIAO-${PV}.tar.bz2 )
	)"

LICENSE="ACE BSD BSD-4 BSD-2 tao? ( sun-iiop RSA )"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="X ciao ipv6 libressl static-libs tao"

COMMON_DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
# TODO probably more
RDEPEND="${COMMON_DEPEND}
	X? ( x11-libs/libXt x11-libs/libXaw )"

DEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )"

S="${WORKDIR}/ACE_wrappers"

src_prepare() {
	sed -i \
		-e 's:SSL_METHOD:const SSL_METHOD:' \
		-e 's/-O3//' \
		configure || die "sed on configure failed"
	mkdir build || die
	export ACE_ROOT="${S}"

	epatch_user
}

src_configure() {
	pushd build >/dev/null || die
	ECONF_SOURCE="${S}"
	econf \
		--enable-lib-all \
		$(use_with X) \
		$(use_enable ipv6) \
		$(use_enable static-libs static)
	popd >/dev/null || die
}

src_compile() {
	# --with-qos needs ACE_HAS_RAPI
	emake -C build
}

src_install() {
	emake -C build ACE_ROOT="${S}" DESTDIR="${D}" install
	# punt gperf stuff
	rm -rf "${D}/usr/bin" "${D}/usr/share"
	# remove PACKAGE_* definitions from installed config.h (#192676)
	sed -i -e "s:^[ \t]*#define[ \t]\+PACKAGE_.*$:/\* & \*/:g" "${D}/usr/include/ace/config.h" || die

	# Install some docs
	dodoc README NEWS ChangeLog AUTHORS VERSION

	prune_libtool_files
}

src_test() {
	emake -C build ACE_ROOT="${S}" check
}

pkg_postinst() {

	local CC_MACHINE=$($(tc-getCC) -dumpmachine)
	if [ -d "/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/$(gcc-fullversion)/include/ace" ]; then
	ewarn "moving /usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/$(gcc-fullversion)/include/ace to"
	ewarn "ace.old"
	ewarn "This is required, as anything trying to compile against ACE will"
	ewarn "have problems with conflicting OS.h files if this is not done."
		mv "/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/$(gcc-fullversion)/include/ace" \
			"/usr/$(get_libdir)/gcc-lib/${CC_MACHINE}/$(gcc-fullversion)/include/ace.old"
	fi
}
