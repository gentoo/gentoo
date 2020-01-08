# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs user

DESCRIPTION="Digital vinyl emulation software"
HOMEPAGE="https://xwax.org/"
SRC_URI="https://xwax.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="alsa jack oss cdda mp3 +fallback"

REQUIRED_USE="|| ( cdda mp3 fallback )
	|| ( alsa jack oss )"

DEPEND="
	media-fonts/dejavu
	media-libs/libsdl
	media-libs/sdl-ttf
	sys-libs/glibc
	sys-libs/pam
	alsa? ( media-libs/alsa-lib )
	cdda? ( media-sound/cdparanoia )
	fallback? ( virtual/ffmpeg )
	jack? ( media-sound/jack-audio-connection-kit )
	mp3? ( media-sound/mpg123 )
"
RDEPEND="${DEPEND}"

DOCS=( README CHANGES )

src_prepare() {
	default
	# Remove the forced optimization from 'CFLAGS' and 'LDFLAGS' in
	# the Makefile
	# Also remove the dependency on the .version target so we don't need
	# git just to build
	sed -i -e 's/\(^\(LD\|C\)FLAGS.*\)-O[0-9]\(.*\)/\1\3/g' \
		-e 's/^xwax\.o:.*\.version//' \
		Makefile || die "sed failed"
}

src_configure() {
	tc-export CC
	econf \
		--prefix "${EROOT}/usr" \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable oss)
}

src_compile() {
	# EXECDIR is the default directory in which xwax will look for
	# the 'xwax-import' and 'xwax-scan' scripts
	emake EXECDIR="\$(BINDIR)" VERSION="${PV}" xwax
}

pkg_preinst() {
	enewgroup ${PN}
}

src_install() {
	# This is easier than setting all the environment variables
	# needed, running the sed script required to get the man directory
	# correct, and removing the GPL-2 after a 'make install' run
	dobin xwax
	newbin scan xwax-scan
	newbin import xwax-import
	doman xwax.1

	dodoc ${DOCS}

	insinto "/etc/security/limits.d"
	newins "${FILESDIR}/xwax-etc-security-limits.conf" xwax.conf
}

pkg_postinst() {
	elog "Be sure to add any users that will be using ${PN} to the"
	elog "\"${PN}\" group. Doing so will allow processes that user"
	elog "runs to request realtime priority."
}
