# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A many featured astrology chart calculation program"
HOMEPAGE="http://www.astrolog.org/astrolog.htm"
SRC_URI="http://www.astrolog.org/ftp/ast54unx.shr"

LICENSE="astrolog"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	sh "${DISTDIR}"/ast54unx.shr || die
}

src_prepare() {
	default

	# remove stripping of created binary, dump hardcoded CFLAGS,
	# respect CC (bug #243606), and CFLAGS (bug #240057)
	sed \
		-e 's:strip:#strip:' -e 's:^CFLAGS = :#CFLAGS = :' \
		-e 's:\tcc :\t$(CC) $(CFLAGS) $(LDFLAGS) :' \
		-i Makefile || die

	# we use /usr/share/astrolog for config and (optional) ephemeris-data-files
	sed -i -e "s:~/astrolog:/usr/share/astrolog:g" astrolog.h || die

	# if we use X, we need to add -L/usr/X11R6/lib to compile succesful
	#use X && sed -i -e "s:-lm -lX11:-lm -lX11 -L/usr/X11R6/lib:g" Makefile

	# if we do NOT use X, we disable it by removing the -lX11 from the Makefile
	# and remove the "#define X11" and "#define MOUSE" from astrolog.h
	use X || ( sed -i -e "s:-lm -lX11:-lm:g" Makefile || die
		   sed -i -e "s:#define X11:/*#define X11:g" astrolog.h || die
		   sed -i -e "s:#define MOUSE:/*#define MOUSE:g" astrolog.h || die)

	# any user may have an own astrolog configfile
	#sed -i -e "s:astrolog.dat:astrolog.dat:g" astrolog.h || die
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin astrolog
	dodoc Helpfile.540 README.1ST README.540 Update.540
	insinto /usr/share/astrolog
	doins astrolog.dat
}

pkg_postinst() {
	elog "There is a sample config file /usr/share/astrolog/astrolog.dat"
	elog "astrolog looks in current dir for a file astrolog.dat before"
	elog "using the file in /usr/share/astrolog"
	elog "If you want extended accuracy of astrolog's calculations you"
	elog "can emerge the optional package \"astrolog-ephemeris\" which"
	elog "needs ~4.7 MB additional diskspace for the ephemeris-files"
}
