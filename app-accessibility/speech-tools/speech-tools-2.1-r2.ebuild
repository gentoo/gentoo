# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic multilib toolchain-funcs

MY_P=${P/speech-/speech_}
PATCHSET="r3"

DESCRIPTION="Speech tools for Festival Text to Speech engine"
HOMEPAGE="http://www.cstr.ed.ac.uk/projects/speech_tools/"
SRC_URI="http://www.festvox.org/packed/festival/${PV}/${MY_P}-release.tar.gz
		 http://dev.gentoo.org/~neurogeek/${PN}/${MY_P}-${PATCHSET}-patches.tar.gz"

LICENSE="FESTIVAL HPND BSD rc regexp-UofT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="nas X"

RDEPEND="
	nas? ( media-libs/nas )
	X? ( x11-libs/libX11
		x11-libs/libXt )
	>=media-libs/alsa-lib-1.0.20-r1
	!<app-accessibility/festival-1.96_beta
	!sys-power/powerman
	>=sys-libs/ncurses-5.6-r2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/speech_tools"

src_prepare() {
	EPATCH_SUFFIX="patch"
	epatch

	sed -i -e 's,{{HORRIBLELIBARCHKLUDGE}},"/usr/$(get_libdir)",' main/siod_main.cc

	#WRT bug #309983
	sed -i -e "s:\(GCC_SYSTEM_OPTIONS =\).*:\1:" "${S}"/config/systems/sparc_SunOS5.mak

	# Fix underlinking, bug #493204
	epatch "${FILESDIR}"/${PN}-2.1-underlinking.patch
}

src_configure() {
	local CONFIG=config/config.in
	sed -i -e 's/@COMPILERTYPE@/gcc42/' ${CONFIG}
	if use nas; then
		sed -i -e "s/#.*\(INCLUDE_MODULES += NAS_AUDIO\)/\1/" ${CONFIG}
	fi
	if ! use X; then
		sed -i -e "s/-lX11 -lXt//" config/modules/esd_audio.mak
	fi
	econf
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" CXX="$(tc-getCXX)" CXX_OTHER_FLAGS="${CXXFLAGS}" CC_OTHER_FLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dolib.so lib/libest*.so*

	dodoc "${S}"/README
	dodoc "${S}"/lib/cstrutt.dtd

	insinto /usr/share/doc/${PF}
	doins -r lib/example_data

	insinto /usr/share/speech-tools
	doins -r config base_class

	insinto /usr/share/speech-tools/lib
	doins -r lib/siod

	cd include
	insinto /usr/include/speech-tools
	doins -r *
	dosym /usr/include/speech-tools /usr/share/speech-tools/include

	cd ../bin
	for file in *; do
		[ "${file}" = "Makefile" ] && continue
		dobin ${file}
		dstfile="${D}/usr/bin/${file}"
		sed -i -e "s:${S}/testsuite/data:/usr/share/speech-tools/testsuite:g" ${dstfile}
		sed -i -e "s:${S}/bin:/usr/$(get_libdir)/speech-tools:g" ${dstfile}
		sed -i -e "s:${S}/main:/usr/$(get_libdir)/speech-tools:g" ${dstfile}

		# This just changes LD_LIBRARY_PATH
		sed -i -e "s:${S}/lib:/usr/$(get_libdir):g" ${dstfile}
	done

	cd "${S}"
	exeinto /usr/$(get_libdir)/speech-tools
	for file in `find main -perm +100 -type f`; do
		doexe ${file}
	done

	#Remove /usr/bin/resynth as it is broken. See bug #253556
	rm "${D}/usr/bin/resynth"
}
