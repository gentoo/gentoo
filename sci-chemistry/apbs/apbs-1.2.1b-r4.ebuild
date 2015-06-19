# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-1.2.1b-r4.ebuild,v 1.17 2013/04/23 14:01:32 jlec Exp $

EAPI="3"

PYTHON_DEPEND="python? 2"

inherit autotools eutils flag-o-matic fortran-2 python toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-3)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Evaluation of electrostatic properties of nanoscale biomolecular systems"
HOMEPAGE="http://www.poissonboltzmann.org/apbs/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="arpack doc mpi openmp python tools"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/maloc[mpi=]
	virtual/blas
	sys-libs/readline
	arpack? ( sci-libs/arpack )
	tools? ( !sci-libs/gts )
	mpi? ( virtual/mpi )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/"${MY_P}-source"

pkg_setup() {
	fortran-2_pkg_setup
	use python && python_set_active_version 2
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-openmp.patch \
		"${FILESDIR}"/${P}-install-fix.patch \
		"${FILESDIR}"/${PN}-1.2.0-contrib.patch \
		"${FILESDIR}"/${PN}-1.2.0-link.patch \
		"${FILESDIR}"/${P}-autoconf-2.64.patch \
		"${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-multilib.patch \
		"${FILESDIR}"/${P}-parallelbuild.patch
	sed "s:GENTOO_PKG_NAME:${PN}:g" \
		-i Makefile.am || die "Cannot correct package name"
	# this test is broken
	sed '/ion-pmf/d' -i examples/Makefile.am || die
	eautoreconf
	find . -name "._*" -exec rm -f '{}' \;
}

src_configure() {
	local myconf="--docdir=${EPREFIX}/usr/share/doc/${PF}"
	use arpack && myconf="${myconf} --with-arpack=${EPREFIX}/usr/$(get_libdir)"

	# check which mpi version is installed and tell configure
	if use mpi; then
		export CC="${EPREFIX}/usr/bin/mpicc"
		export F77="${EPREFIX}/usr/bin/mpif77"

		if has_version sys-cluster/mpich; then
	 		myconf="${myconf} --with-mpich=${EPREFIX}/usr"
		elif has_version sys-cluster/mpich2; then
			myconf="${myconf} --with-mpich2=${EPREFIX}/usr"
		elif has_version sys-cluster/openmpi; then
			myconf="${myconf} --with-openmpi=${EPREFIX}/usr"
		fi
	fi || die "Failed to select proper mpi implementation"

	# we need the tools target for python
	if use python && ! use tools; then
		myconf="${myconf} --enable-tools"
	fi

	econf \
		--disable-maloc-rebuild \
		--enable-shared \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		$(use_enable openmp) \
		$(use_enable python) \
		$(use_enable tools) \
		${myconf}
}

src_test() {
	export LC_NUMERIC=C
	cd examples && make test \
		|| die "Tests failed"
	grep -q 'FAILED' "${S}"/examples/TESTRESULTS.log && die "Tests failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install \
		|| die "make install failed"

	if use tools; then
		mv tools/mesh/{,mesh-}analysis || die
		dobin tools/mesh/* || die

		if use arpack; then
			dobin tools/arpack/* || die
		fi

		insinto /usr/share/${PN}
		doins -r tools/conversion || die
		doins -r tools/visualization/opendx || die

		dobin tools/manip/{born,coulomb} || die

		doins -r tools/matlab || die
	fi

	insinto $(python_get_sitedir)/${PN}
	doins tools/manip/*.py || die

	if use python && ! use mpi; then
		insinto $(python_get_sitedir)/${PN}
		doins tools/python/{*.py,*.pqr,*.so} || die
		doins tools/python/*/{*.py,*.so} || die
	fi

	dodoc AUTHORS INSTALL README NEWS ChangeLog \
		|| die "Failed to install docs"

	if use doc; then
		dohtml -r doc/* || die "Failed to install html docs"
	fi
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
