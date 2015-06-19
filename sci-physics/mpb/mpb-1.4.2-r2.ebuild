# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/mpb/mpb-1.4.2-r2.ebuild,v 1.7 2013/02/19 19:44:18 jlec Exp $

EAPI=4

inherit eutils autotools flag-o-matic toolchain-funcs

DESCRIPTION="Photonic band structure program"
SRC_URI="http://ab-initio.mit.edu/mpb/${P}.tar.gz"
HOMEPAGE="http://ab-initio.mit.edu/mpb/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples hdf5 mpi"

SLOT="0"

RDEPEND="virtual/lapack
	dev-scheme/guile
	sci-libs/libctl
	sci-libs/fftw:2.1[mpi?]
	sys-libs/readline
	hdf5? ( sci-libs/hdf5 )
	mpi? ( virtual/mpi )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-autotools.patch \
		"${FILESDIR}"/${P}-guile18.patch \
		"${FILESDIR}"/${P}-headers.patch
	cd "${S}"
	eautoreconf
	# version with inversion symmetry (mpbi).
	cp -r "${S}" "${S}_inv" || die
	# version with hermitian eps (mpbh).
	cp -r "${S}" "${S}_herm" || die
	# mpi versions (mpb-mpi).
	if use mpi; then
		cp -r "${S}" "${S}_mpi" || die
		cp -r "${S}" "${S}_inv_mpi" || die
		cp -r "${S}" "${S}_herm_mpi" || die
	fi
	tc-export CC
}

src_configure() {
	# enable legacy API for hdf-1.8
	use hdf5 && append-cflags -DH5_USE_16_API
	#
	local myconf=(
		--with-libctl="${EPREFIX}/usr/share/libctl"
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		$(use_with hdf5)
	)

	econf "${myconf[@]}"

	cd "${S}_inv"
	econf "${myconf[@]}" \
		--with-inv-symmetry

	cd "${S}_herm"
	econf "${myconf[@]}" \
		--with-hermitian-eps

	if use mpi; then
		cd "${S}_mpi"
		econf "${myconf[@]}" \
			--with-mpi
		cd "${S}_inv_mpi"
		econf "${myconf[@]}" \
			--with-inv-symmetry \
			--with-mpi
		cd "${S}_herm_mpi"
		econf "${myconf[@]}" \
			--with-hermitian-eps \
			--with-mpi \
			CC=mpicc
	fi
}

src_compile() {
	local d
	for d in .  _inv _herm; do
		cd "${S}${d}"
		emake -C mpb-ctl ctl-io.c
		emake
	done
	if use mpi; then
		for d in .  _inv _herm; do
			cd "${S}${d}_mpi"
			emake -C mpb-ctl ctl-io.c CC=mpicc
			emake CC=mpicc LD=mpicc
		done
	fi
}

src_install() {
	einstall
	dodoc README NEWS AUTHORS COPYRIGHT ChangeLog TODO
	use doc && dohtml doc/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r mpb-ctl/examples
	fi

	newbin "${S}_inv"/mpb-ctl/.mpb mpbi
	newbin "${S}_herm"/mpb-ctl/.mpb mpbh

	einfo "Several versions of mpb have been installed:"
	einfo "mpb : regular version"
	einfo "mpbi: configured for inversion symmetry"
	einfo "mpbh: configured for hermitian epsilon"
	if use mpi; then
		newbin "${S}_mpi"/mpb-ctl/.mpb mpb-mpi
		newbin "${S}_inv_mpi"/mpb-ctl/.mpb mpbh-mpi
		newbin "${S}_herm_mpi"/mpb-ctl/.mpb mpbi-mpi
		einfo "mpb-mpi : regular version with mpi"
		einfo "mpbi-mpi: configured for inversion symmetry with mpi"
		einfo "mpbh-mpi: configured for hermitian epsilon with mpi"
	fi
}
