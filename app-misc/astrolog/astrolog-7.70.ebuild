# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please also check if app-misc/astrolog-ephemeris archive needs update

inherit toolchain-funcs

MY_PV=$(ver_rs 1 '')

DESCRIPTION="A many featured astrology chart calculation program"
HOMEPAGE="
	https://www.astrolog.org/astrolog.htm
	https://github.com/CruiserOne/Astrolog
"
SRC_URI="https://www.astrolog.org/ftp/ast${MY_PV:0:2}src.zip"

S="${WORKDIR}"

LICENSE="AGPL-3 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	# we use /usr/share/astrolog for config and (optional) ephemeris-data-files
	local cfgargs=( -e "s:~/astrolog:/usr/share/astrolog:g" )
	# if we do NOT use X, we comment the "#define X11" in astrolog.h
	use X || cfgargs+=( -e "s:#define X11://&:g" )

	sed -i "${cfgargs[@]}" astrolog.h || die

	local makeargs=(
		# respect CXX (bug #243606), and LDFLAGS
		-e 's:\tcc :\t$(CXX) $(LDFLAGS) :'
		# respect -O flags
		-e '/^CPPFLAGS/s:-O ::'
	)
	sed -i "${makeargs[@]}" Makefile || die
}

src_compile() {
	local libs=( -lm -ldl )
	# we need to link with -lX11 if the X use is set
	use X && libs+=( -lX11 )

	# Makefile contains stripping flag in LIBS. It is easier to overload it
	# here because we need to control LIBS content with X use anyway.
	emake LIBS="${libs[*]}"
}

src_install() {
	dobin astrolog
	dodoc astrolog.doc changes.doc
	insinto /usr/share/astrolog
	doins astrolog.as
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "There is a sample config file /usr/share/astrolog/astrolog.as"
		elog "astrolog looks in current dir for a file astrolog.as before"
		elog "using the file in /usr/share/astrolog"
		elog "If you want extended accuracy of astrolog's calculations you"
		elog "can emerge the optional package \"astrolog-ephemeris\" which"
		elog "needs ~32.9 MB additional diskspace for the ephemeris-files"
	fi
}
