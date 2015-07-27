# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/chuck/chuck-1.3.5.1.ebuild,v 1.1 2015/07/27 16:41:24 polynomial-c Exp $

EAPI=5
inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Strongly-timed, Concurrent, and On-the-fly
Audio Programming Language"
HOMEPAGE="http://chuck.cs.princeton.edu/release/"
SRC_URI="http://chuck.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+alsa jack examples"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	media-libs/libsndfile
	app-eselect/eselect-chuck"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

REQUIRED_USE="|| ( alsa jack )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.1.1-hid-smc.patch \
		"${FILESDIR}"/${PN}-1.3.5.1-makefile.patch
}

compile_backend() {
	backend=$1
	pushd "${S}/src" &>/dev/null || die
	einfo "Compiling against ${backend}"
	emake  CC=$(tc-getCC) CXX=$(tc-getCXX) linux-${backend}
	mv chuck{,-${backend}}
	emake clean
	popd &>/dev/null || die
}

src_compile() {
	# when compile with athlon or athlon-xp flags
	# chuck crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	use jack && compile_backend jack
	use alsa && compile_backend alsa
}

src_install() {
	use jack && dobin src/chuck-jack
	use alsa && dobin src/chuck-alsa

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
}

pkg_postinst() {
	elog "Chuck now can use many audio engines, so you can specify audio engine"
	elog "with chuck-{jack,alsa}"
	elog "Or you can use 'eselect chuck' to set the audio engine"

	einfo "Calling eselect chuck update..."
	eselect chuck update --if-unset
}
