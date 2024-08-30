# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-any-r1

DESCRIPTION="Scalable Library for Eigenvalue Problem Computations"
HOMEPAGE="https://slepc.upv.es/"
SRC_URI="
	!doc? ( https://slepc.upv.es/download/distrib/${P}.tar.gz )
	doc? ( https://slepc.upv.es/download/distrib/${PN}-with-docs-${PV}.tar.gz )"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arpack complex-scalars doc +examples mpi"

REQUIRED_USE="arpack? ( mpi )"

RDEPEND="
	=sci-mathematics/petsc-$(ver_cut 1-2)*:=[examples,mpi=,complex-scalars=]
	arpack? ( sci-libs/arpack[mpi=] )
	mpi? ( virtual/mpi )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-build/cmake
"

MAKEOPTS="${MAKEOPTS} V=1"

src_unpack() {
	use doc || unpack ${P}.tar.gz
	use doc && unpack ${PN}-with-docs-${PV}.tar.gz
}

src_configure() {
	# *sigh*
	addpredict "${PETSC_DIR}"/.nagged

	# Make sure that the environment is set up correctly:
	unset PETSC_DIR
	unset PETSC_ARCH
	source "${EPREFIX}"/etc/env.d/99petsc
	export PETSC_DIR
	export PETSC_ARCH
	export SLEPC_DIR="${S}"

	# configure is a custom python script and doesn't want to have default
	# configure arguments that we set with econf
	if use arpack; then
		./configure \
			--prefix="${EPREFIX}/usr/$(get_libdir)/slepcdir" \
			--with-arpack=1 \
			--with-arpack-lib="$(usex mpi "-lparpack -larpack" "-larpack")"
	else
		./configure \
			--prefix="${EPREFIX}/usr/$(get_libdir)/slepcdir" \
			--with-arpack=0
	fi
}

src_install() {
	emake DESTDIR="${ED}" install

	#
	# Clean up the mess:
	#

	# put all include directories under a proper subdirectory
	mkdir "${ED}"/usr/include || die "mkdir failed (include)"
	mv "${ED}"/usr/{$(get_libdir)/slepcdir/include,include/slepc} || die "mv failed (include)"

	# put libraries and pkconfig file into proper place
	mv "${ED}"/usr/$(get_libdir)/slepcdir/lib/{libslepc*,pkgconfig} \
		"${ED}/usr/$(get_libdir)" || die "mv failed (lib)"

	# move share to proper location
	mv "${ED}"/usr/{$(get_libdir)/slepcdir/share,share} || die "mv failed (share)"

	# fix pc files:
	sed -i \
		-e 's#include$#include/slepc#' \
		-e "s#lib\$#$(get_libdir)#" \
		-e "s#^prefix=.*slepcdir\$#prefix=${EPREFIX}/usr#" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/*.pc || die "sed failed (pkgconfig)"

	# recreate a "valid" slepcdir:
	for i in "${ED}"/usr/$(get_libdir)/*; do
		[ $(basename $i) = slepcdir ] && continue
		ln -s "${EPREFIX}/usr/$(get_libdir)/$(basename $i)" \
			"${ED}/usr/$(get_libdir)/slepcdir/lib/$(basename $i)" || die "ln failed (slepcdir)"
	done
	ln -s "${EPREFIX}"/usr/include/slepc/ \
		"${ED}/usr/$(get_libdir)/slepcdir/include" || die "ln failed (slepcdir)"
	mkdir "${ED}/usr/$(get_libdir)/slepcdir/share" || die "mkdir fialed (slepcdir)"
	ln -s "${EPREFIX}"/usr/share/slepc/ \
		"${ED}/usr/$(get_libdir)/slepcdir/share/slepc" || die "ln failed (slepcdir)"

	if use examples; then
		mkdir -p "${ED}"/usr/share/doc/${PF} || die "mkdir failed (examples)"
		mv "${ED}"/usr/share/slepc/examples "${ED}"/usr/share/doc/${PF} || die "mv failed (examples)"
		ln -s "${EPREFIX}"/usr/share/doc/${PF}/examples "${ED}"/usr/share/slepc/examples || die "ln failed (examples)"
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -r "${ED}"/usr/share/slepc/examples || die "rm failed (examples)"
	fi

	if use doc ; then
		dodoc docs/slepc.pdf
		docinto html
		dodoc -r docs/*.html docs/manualpages
	fi

	# add PETSC_DIR to environmental variables
	cat >> 99slepc <<- EOF
		SLEPC_DIR=${EPREFIX}/usr/$(get_libdir)/slepcdir
	EOF
	doenvd 99slepc
}
