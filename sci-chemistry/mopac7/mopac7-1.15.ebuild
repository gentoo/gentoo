# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Autotooled, updated version of a powerful, fast semi-empirical package"
HOMEPAGE="http://sourceforge.net/projects/mopac7/"
SRC_URI="
	http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz
	http://wwwuser.gwdg.de/~ggroenh/qmmm/mopac/dcart.f
	http://wwwuser.gwdg.de/~ggroenh/qmmm/mopac/gmxmop.f"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux"
IUSE="gmxmopac7 static-libs"

DEPEND="dev-libs/libf2c"
RDEPEND="${DEPEND}"

src_prepare() {
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
}

src_configure() {
	#set -std=legacy -fno-automatic according to
	#http://www.bioinformatics.org/pipermail/ghemical-devel/2008-August/000763.html
	FFLAGS="${FFLAGS} -std=legacy -fno-automatic" econf
}

src_compile() {
	emake
	if use gmxmopac7; then
		einfo "Making mopac7 lib for gromacs"
		mkdir "${S}"/fortran/libgmxmopac7 && cd "${S}"/fortran/libgmxmopac7
		cp -f ../SIZES ../*.f "${FILESDIR}"/Makefile . || die
		emake clean
		cp -f "${DISTDIR}"/gmxmop.f "${DISTDIR}"/dcart.f . || die
		sed "s:GENTOOVERSION:${PV}:g" -i Makefile
		emake FC=$(tc-getFC)
		if use static-libs; then
			emake static
		fi
	fi
}

src_install() {
	# A correct fix would have a run_mopac7.in with @bindir@ that gets
	# replaced by configure, and run_mopac7 added to AC_OUTPUT in configure.ac
	sed -i "s:./fortran/mopac7:mopac7:g" run_mopac7

	make DESTDIR="${D}" install || die
	dodoc AUTHORS README ChangeLog
	if use gmxmopac7; then
		cd "${S}"/fortran/libgmxmopac7
		dolib.so libgmxmopac7.so*
		if use static-libs; then
			dolib.a libgmxmopac7.a
		fi
	fi
}
