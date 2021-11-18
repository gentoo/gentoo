# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="Autotooled, updated version of a powerful, fast semi-empirical package"
HOMEPAGE="https://sourceforge.net/projects/mopac7/"
SRC_URI="
	http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz
	http://wwwuser.gwdg.de/~ggroenh/qmmm/mopac/dcart.f
	http://wwwuser.gwdg.de/~ggroenh/qmmm/mopac/gmxmop.f"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux"
IUSE="gmxmopac7"

DEPEND="dev-libs/libf2c"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Install the executable
	sed -i \
		-e "s:noinst_PROGRAMS = mopac7:bin_PROGRAMS = mopac7:g" \
		fortran/Makefile.am \
		|| die "sed failed: install mopac7"
	# Install the script to run the executable
	sed -i \
		-e "s:EXTRA_DIST = autogen.sh run_mopac7:bin_SCRIPTS = run_mopac7:g" \
		Makefile.am \
		|| die "sed failed: install run_mopac7"

	eautoreconf
	append-fflags -std=legacy -fno-automatic
}

src_configure() {
	econf --disable-static
}

src_compile() {
	emake
	if use gmxmopac7; then
		einfo "Making mopac7 lib for gromacs"
		mkdir "${S}"/fortran/libgmxmopac7 || die
		cd "${S}"/fortran/libgmxmopac7 || die
		cp -n ../SIZES ../*.f "${FILESDIR}"/Makefile . || die
		emake clean
		cp -n "${DISTDIR}"/gmxmop.f "${DISTDIR}"/dcart.f . || die
		sed "s:GENTOOVERSION:${PV}:g" -i Makefile || die
		emake FC=$(tc-getFC)
	fi
}

src_install() {
	# A correct fix would have a run_mopac7.in with @bindir@ that gets
	# replaced by configure, and run_mopac7 added to AC_OUTPUT in configure.ac
	sed -i "s:./fortran/mopac7:mopac7:g" run_mopac7 || die

	default

	if use gmxmopac7; then
		cd "${S}"/fortran/libgmxmopac7 || die
		dolib.so libgmxmopac7.so*
	fi

	find "${ED}" -name '*.la' -delete || die
}
