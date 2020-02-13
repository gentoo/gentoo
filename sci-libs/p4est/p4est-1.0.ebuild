# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# The build system currently fails with everything newer than 1.11.
WANT_AUTOMAKE=1.11

inherit autotools eutils toolchain-funcs

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="
	https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/cburstedde/libsc/archive/v${PV}.tar.gz -> libsc-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug doc examples mpi romio static-libs +vtk-binary"
REQUIRED_USE="romio? ( mpi )"

RDEPEND="
	~sci-libs/libsc-${PV}[mpi=,romio=,static-libs=]
	dev-lang/lua:*
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio=] )"

DEPEND="
	${RDEPEND}
	sys-devel/automake:1.11
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default

	# Inject libsc to get  all parts of the build system...
	rmdir "${S}/sc" || die "rmdir failed"
	mv "${WORKDIR}/libsc-${PV}" "${S}/sc" || die "mv failed"

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	AT_M4DIR="${WORKDIR}/${P}/config ${WORKDIR}/${P}/sc/config"
	eautoreconf

	sed -i \
		"s/P4EST_SC_DIR\/etc/P4EST_SC_DIR\/share\/libsc/" \
		"${S}"/configure || die "sed failed"

	sed -i \
		"s/libsc\.la/libsc\.so/" \
		"${S}"/configure || die "sed failed"
}

src_configure() {
	# avoid underlinkage
	LDFLAGS="${LDFLAGS} -lsc"

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable romio mpiio)
		$(use_enable static-libs static)
		$(use_enable vtk-binary)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-sc="${EPREFIX}/usr"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use doc && dodoc -r doc/*

	if use examples
	then
		docinto examples
		dodoc -r example/*
		docompress -x /usr/share/doc/${PF}/examples
	else
		# Remove compiled example binaries in case of -examples:
		rm -r "${ED}"/usr/bin || die "rm failed"
	fi

	# Fix wrong installation paths:
	dodir /usr/share/p4est
	mv "${ED}"/usr/share/data "${ED}"/usr/share/p4est/data || die "mv failed"
	mv "${ED}"/etc/* "${ED}"/usr/share/p4est || die "mv failed"
	rmdir "${ED}"/etc/ || die "rmdir failed"
}
