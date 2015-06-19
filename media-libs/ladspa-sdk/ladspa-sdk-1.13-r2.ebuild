# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ladspa-sdk/ladspa-sdk-1.13-r2.ebuild,v 1.9 2014/01/26 12:14:13 ago Exp $

EAPI=5

inherit eutils multilib toolchain-funcs portability flag-o-matic multilib-minimal

MY_PN=${PN/-/_}
MY_P=${MY_PN}_${PV}

DESCRIPTION="The Linux Audio Developer's Simple Plugin API"
HOMEPAGE="http://www.ladspa.org/"
SRC_URI="http://www.ladspa.org/download/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r2
	!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND=">=sys-apps/sed-4"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	cd "${WORKDIR}/${MY_PN}/src"
	epatch "${FILESDIR}"/${P}-properbuild.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-no-LD.patch

	sed -i -e 's:-sndfile-play*:@echo Disabled \0:' \
		makefile || die "sed makefile failed (sound playing tests)"

	cd "${S}"
	multilib_copy_sources
}

multilib_src_compile() {
	cd src
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		DYNAMIC_LD_LIBS="$(dlopen_lib)" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		targets
}

multilib_src_test() {
	cd src
	emake test
}

multilib_src_install() {
	cd src
	emake INSTALL_PLUGINS_DIR="/usr/$(get_libdir)/ladspa" \
		DESTDIR="${D}" \
		MKDIR_P="mkdir -p" \
		install
}

multilib_src_install_all() {
	einstalldocs
	dohtml doc/*.html

	# Needed for apps like rezound
	# emul-linux-soundlibs doesnt seem to install this, so keep it only for the
	# default abi.
	dodir /etc/env.d
	echo "LADSPA_PATH=/usr/$(get_libdir)/ladspa" > "${D}/etc/env.d/60ladspa"
}
