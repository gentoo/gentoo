# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Techniques + Paradigms for Expressive Synthesis, Transformation, Rendering of Environmental Audio"
HOMEPAGE="http://taps.cs.princeton.edu/"
SRC_URI="http://taps.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa doc jack oss"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit:0 )
	alsa? ( >=media-libs/alsa-lib-0.9:0 )
	media-libs/libsndfile:0
	media-libs/freeglut:0
	virtual/opengl:0
	virtual/glu:0
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	sys-devel/bison:0
	sys-devel/flex:0"

pkg_setup() {
	if ! use alsa && ! use jack && ! use oss; then
		eerror "One of the following USE flags is needed: jack, alsa or oss"
		die "Please set at least one audio engine type"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch

	# Respect LDFLAGS/CC
	for bend in alsa jack oss; do
		sed -i -e "s:gcc -o:\$(CC) \$(LDFLAGS) -o :" \
			-e "s:-O3 -c:\$(CFLAGS) -c:" \
			-e "s:make -C:\$(MAKE) -C :" \
			"${S}/src/makefile.${bend}" || die
	done

	# Avoid "make jobserver unavailable" warning
	sed -i -e "s:-make:\$(MAKE):g" \
		"${S}/src/makefile" || die

	sed -i -e "s:-make:\$(MAKE):g" \
		"${S}/scripting/chuck-1.2.1.2/src/makefile" || die

	epatch "${FILESDIR}"/${PF}-underlinking-alsa-pthread.patch
}

compile_backend() {
	backend=$1
	einfo "Compiling against ${backend}"

	cd "${S}/scripting/chuck-1.2.1.2/src"
	emake -f "makefile.${backend}" \
		CC=$(tc-getCC) CXX=$(tc-getCXX) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"

	cd "${S}/src"
	emake -f "makefile.${backend}" \
		CC=$(tc-getCC) CXX=$(tc-getCXX) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"

	mv taps{,-${backend}} || die
	emake -f makefile clean
	cd "${S}/scripting/chuck-1.2.1.2/src"
	emake -f makefile clean
}

src_compile() {
	# When compiled with athlon or athlon-xp flags
	# chuck crashes on removing a shred with a double free or corruption,
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	use jack && compile_backend jack
	use alsa && compile_backend alsa
	use oss && compile_backend oss
}

src_install() {
	use jack && dobin src/taps-jack
	use alsa && dobin src/taps-alsa
	use oss && dobin src/taps-oss

	dodoc AUTHORS BUGS DEVELOPER PROGRAMMER QUICKSTART README THANKS TODO VERSIONS

	if use doc ; then
		for tapedir in `find examples/* -type d -maxdepth 0`; do
			docinto $tapedir
			dodoc `find $tapedir/* -type f -maxdepth 0`
			for tapedir2 in `find $tapedir/* -type d -maxdepth 0`; do
				docinto $tapedir2
				dodoc `find $tapedir2/* -type f -maxdepth 0`
			done
		done
		docinto doc
		dodoc doc/*
	fi
}
