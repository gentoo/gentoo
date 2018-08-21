# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs flag-o-matic

DESCRIPTION="Strongly-timed, concurrent, and on-the-fly audio programming language"
HOMEPAGE="http://chuck.cs.princeton.edu/"
SRC_URI="http://chuck.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa jack examples"
REQUIRED_USE="|| ( alsa jack )"

RDEPEND="app-eselect/eselect-chuck
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0.0-hid-smc.patch
	"${FILESDIR}"/${PN}-1.4.0.0-makefile.patch
)

compile_backend() {
	backend=$1
	pushd "${S}/src" &>/dev/null || die
	einfo "Compiling against ${backend}"
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) linux-${backend}
	mv chuck{,-${backend}} || die
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
	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Chuck now can use multiple audio engines, so you can specify"
		elog "the preferred audio engine with chuck-{jack,alsa}"
		elog "Or you can use 'eselect chuck' to set the audio engine"
	fi
	eselect chuck update --if-unset
}
