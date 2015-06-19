# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/nusmv/nusmv-2.5.2.ebuild,v 1.3 2012/04/25 17:08:40 jlec Exp $

inherit eutils flag-o-matic toolchain-funcs

NUSMV_PN="NuSMV"
NUSMV_PV="${PV}"
NUSMV_P="${NUSMV_PN}-${NUSMV_PV}"
NUSMV_A="${NUSMV_P}.tar.gz"
NUSMV_S="${WORKDIR}/${NUSMV_P}/nusmv"

MINISAT_PN="MiniSat"
MINISAT_PV="1.14"
MINISAT_P="${MINISAT_PN}_v${MINISAT_PV}"
MINISAT_A="${MINISAT_P}_src.zip"
MINISAT_S="${WORKDIR}/${NUSMV_P}/MiniSat/${MINISAT_P}"

CUDD_PN="cudd"
CUDD_PV="2.4.1.1"
CUDD_P="${CUDD_PN}-${CUDD_PV}"
#CUDD_A is none
CUDD_S="${WORKDIR}/${NUSMV_P}/${CUDD_P}"

DESCRIPTION="NuSMV: new symbolic model checker"
HOMEPAGE="http://nusmv.irst.itc.it/"
SRC_URI="http://nusmv.fbk.eu/distrib/${NUSMV_A}
		minisat? ( mirror://gentoo/${MINISAT_A} )"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="minisat examples"
RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
		virtual/latex-base
		dev-texlive/texlive-latexextra
		app-text/ghostscript-gpl
		www-client/lynx
		dev-lang/perl"
# the above 4 are for docs, which aren't optional yet patches welcome to
# avoid building the docs but I suspect anybody using this package will
# actually need them
S="${NUSMV_S}"

src_unpack() {
	unpack ${NUSMV_A}
	if use minisat; then
		cd "${WORKDIR}"/${NUSMV_P}/MiniSat
		unpack ${MINISAT_A}
		epatch ${MINISAT_P}_nusmv.patch
		epatch "${FILESDIR}"/${MINISAT_P}-optimizedlib.patch
		epatch "${FILESDIR}"/${MINISAT_P}_gcc41.patch
	fi

	cd "${CUDD_S}"
	if [[ "$(tc-arch)" = amd64 ]] ; then
		mv Makefile_64bit Makefile || die
	fi
	sed -i Makefile -e 's/-mcpu=[^\s]*//' || die

	for i in ${NUSMV_S}/doc/{user-man,tutorial}/Makefile.in ; do
		sed -i.orig \
			'/install_sh_DATA/s!$(datadir)!$(DESTDIR)$(datadir)!g' \
			${i} || die "sed $i failed"
	done
}

src_compile() {
	if [[ "$(tc-arch)" = x86 ]] ; then
		append-flags -DNUSMV_SIZEOF_VOID_P=4 -DNUSMV_SIZEOF_LONG=4 -DNUSMV_SIZEOF_INT=4
	fi

	rm -f ${NUSMV_S}/${MINISAT_P}
	if use minisat; then
		cd ${MINISAT_S}
		# do NOT merge these targets
		emake COPTIMIZE="${CFLAGS}" r || die "Failed to build minisat bin"
		emake COPTIMIZE="${CFLAGS}" lr || die "Failed to build minisat lib"
		ln -sf ${MINISAT_S} "${WORKDIR}"/${NUSMV_P}/${MINISAT_P}
	fi

	cd ${CUDD_S}
	emake clean || die "Failed to clean cudd out."
	emake \
		CPP="$(tc-getCPP)" CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" ICFLAGS="${CFLAGS}" \
		|| die "Failed to build cudd."

	local myconf="$(use_enable minisat) --enable-pslparser"
	if use minisat; then
		myconf="${myconf}
			--with-minisat-incdir=../${MINISAT_P}
			--with-minisat-libdir=../${MINISAT_P}"
	fi

	cd ${NUSMV_S}
	econf ${myconf}
	emake || die "emake failed"

	VARTEXFONTS="${T}"/fonts emake docs
}

src_install() {
	into /usr
	if use minisat; then
		newbin ${MINISAT_S}/minisat_release minisat
	fi

	dodir /usr/share/nusmv/doc
	cd ${NUSMV_S}
	emake DESTDIR="${D}" install || die "emake install failed"
	# duplicate items
	rm -f "${D}"/usr/share/nusmv/{LGPL-2.1,README*,NEWS}
	# real docs
	dodoc README* NEWS AUTHORS
	dodoc doc/tutorial/tutorial.pdf
	dodoc doc/user-man/nusmv.pdf

	# move package-installed docs
	mv "${D}"/usr/share/nusmv/doc/* "${D}"/usr/share/doc/${PF}/
	rmdir "${D}"/usr/share/nusmv/doc

	# clean out examples if not needed
	if use !examples ; then
		rm -rf "${D}"/usr/share/nusmv/examples || die "Failed to remove examples"
	fi
}

src_test() {
	cd ${NUSMV_S}
	emake check || die "emake check failed"
}
