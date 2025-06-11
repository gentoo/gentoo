# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

# Columbia University only uses the third component, e.g. cku211.tar.gz for
# what we would call 8.0.211. 4-5 are for betas if used.
MY_P="cku$(ver_cut 3-5)"
MY_P=${MY_P/_/-}

# ckermit gets releases very infrequently, so don't be too afraid to
# package betas. It's better than it being unbuildable and so on.
DESCRIPTION="Combined serial and network communication software package"
HOMEPAGE="https://www.kermitproject.org/"
SRC_URI="
	https://www.kermitproject.org/ftp/kermit/archives/${MY_P}.tar.gz
	https://www.kermitproject.org/ftp/kermit/test/tar/${MY_P}.tar.gz
"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 x86"
IUSE="ncurses"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.2:= )"
RDEPEND="
	${DEPEND}
	net-dialup/lrzsz
"
BDEPEND="ncurses? ( virtual/pkgconfig )"

PATCHES=(
	# TODO: Rebase to fix cross?
	#"${FILESDIR}"/${PN}-8.0.211-build-wart.patch

	"${FILESDIR}"/${PN}-10.0.414_beta11-fix-makefile-typos.patch
)

src_prepare() {
	default

	#tc-export_build_env BUILD_CC
}

src_compile() {
	# "ckcfn3.c:224:16: error: type of 'sndfilter' does not match original declaration"
	filter-lto

	# We don't enable any of the telnet/ftp authentication stuff
	# since there are other packages which do these things better
	# USE="kerberos pam shadow ssl zlib"
	append-cppflags -DNO_AUTHENTICATION -DNOLOGIN -DNOFTP

	if use ncurses; then
		append-cppflags "-DCK_NCURSES"
		append-cppflags "$($(tc-getPKG_CONFIG) --cflags ncurses)"
		append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"
	fi

	append-cppflags -DHAVE_PTMX # bug #202840
	append-cppflags -DHAVE_CRYPT_H -DHAVE_OPENPTY
	append-cppflags -DNOARROWKEYS # bug #669332

	local emakeargs=(
		CC="$(tc-getCC)"
		CC2="$(tc-getCC)"
		KFLAGS="${CPPFLAGS} ${CFLAGS} -std=gnu17"
		LIBS="-lcrypt -lresolv -lutil ${LIBS}"
		LNKFLAGS="${LDFLAGS}"
	)

	emake "${emakeargs[@]}" linuxa
}

src_install() {
	dodir /usr/bin /usr/share/man/man1

	emake DESTDIR="${ED}" prefix=/usr manroot=/usr/share install
	dodoc *.txt

	# make the correct symlink
	rm "${ED}"/usr/bin/kermit-sshsub || die
	dosym kermit /usr/bin/kermit-sshsub
}
