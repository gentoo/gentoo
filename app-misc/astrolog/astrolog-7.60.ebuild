# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with app-misc/astrolog-ephemeris

inherit toolchain-funcs

DESCRIPTION="A many featured astrology chart calculation program"
HOMEPAGE="https://www.astrolog.org/astrolog.htm"
SRC_URI="https://www.astrolog.org/ftp/ast74src.zip"

LICENSE="astrolog"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-7.60-drop-resiters.patch
)

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

	# if we do NOT use X, we disable it by removing the -lX11 from the Makefile
	# and remove the "#define X11" and "#define MOUSE" from astrolog.h
	use X || ( sed -i -e "s:-lm -lX11:-lm:g" Makefile || die
		   sed -i -e "s:#define X11:/*#define X11:g" astrolog.h || die
		   sed -i -e "s:#define MOUSE:/*#define MOUSE:g" astrolog.h || die)
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin astrolog
	dodoc astrolog.doc changes.doc
	insinto /usr/share/astrolog
	doins astrolog.as
}

pkg_postinst() {
	elog "There is a sample config file /usr/share/astrolog/astrolog.as"
	elog "astrolog looks in current dir for a file astrolog.as before"
	elog "using the file in /usr/share/astrolog"
	elog "If you want extended accuracy of astrolog's calculations you"
	elog "can emerge the optional package \"astrolog-ephemeris\" which"
	elog "needs ~32.9 MB additional diskspace for the ephemeris-files"
}
