# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Strongly-timed, Concurrent, and On-the-fly
Audio Programming Language"
HOMEPAGE="http://chuck.cs.princeton.edu/release/"
SRC_URI="http://chuck.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="oss jack alsa examples"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	media-libs/libsndfile
	app-admin/eselect"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	local cnt=0
	use jack && cnt="$((${cnt} + 1))"
	use alsa && cnt="$((${cnt} + 1))"
	use oss && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -eq 0 ]] ; then
		eerror "One of the following USE flags is needed: jack, alsa or oss"
		die "Please set one audio engine type"
	elif [[ "${cnt}" -ne 1 ]] ; then
		ewarn "You have set ${P} to use multiple audio engine."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.2.1.1-hid-smc.patch \
		"${FILESDIR}"/${P}-gcc44.patch
}

src_compile() {
	# when compile with athlon or athlon-xp flags
	# chuck crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	use jack && compile_backend jack
	use alsa && compile_backend alsa
	use oss && compile_backend oss
}

compile_backend() {
	backend=$1
	einfo "Compiling against ${backend}"
	cd "${S}/src"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
	mv chuck{,.${backend}}
	emake -f "makefile.${backend}" clean
}

src_install() {
	use jack && dobin src/chuck.jack
	use alsa && dobin src/chuck.alsa
	use oss && dobin src/chuck.oss

	dodoc AUTHORS DEVELOPER PROGRAMMER QUICKSTART README THANKS TODO VERSIONS
	docinto doc
	dodoc doc/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins $(find examples -type f)
		for dir in $(find examples/* -type d); do
			insinto /usr/share/doc/${PF}/"${dir}"
			doins "${dir}"/*
		done
	fi

	dodir /usr/share/eselect/modules
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/chuck.eselect-0.1 chuck.eselect
}

pkg_postinst() {
	elog "Chuck now can use many audio engines, so you can specify audio engine"
	elog "with chuck.{jack,alsa,oss}"
	elog "Or you can use 'eselect chuck' to set the audio engine"

	einfo "Calling eselect chuck update..."
	eselect chuck update --if-unset
}
