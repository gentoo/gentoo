# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit autotools flag-o-matic lua-single toolchain-funcs

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cburstedde/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
else
	SRC_URI="
		https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/cburstedde/libsc/archive/v${PV}.tar.gz -> libsc-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

# TODO petsc
IUSE="debug doc examples mpi openmp romio threads +vtk-binary"
REQUIRED_USE="${LUA_REQUIRED_USE}
	romio? ( mpi )"

RDEPEND="${LUA_DEPS}
	~sci-libs/libsc-${PV}[${LUA_SINGLE_USEDEP},mpi=,openmp=,romio=,threads=]
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio=] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-fix_aclocal.patch
	"${FILESDIR}"/${PN}-2.3-add_soname.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	lua-single_pkg_setup
}

src_prepare() {
	default

	# Inject libsc to get  all parts of the build system...
	if ! [[ ${PV} = *9999* ]]; then
		rmdir "${S}/sc" || die "rmdir failed"
		mv "${WORKDIR}/libsc-${PV}" "${S}/sc" || die "mv failed"
	fi

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	AT_M4DIR="${WORKDIR}/${P}/config ${WORKDIR}/${P}/sc/config"
	eautoreconf

	sed -i \
		"s/P4EST_SC_DIR\/etc/P4EST_SC_DIR\/share\/libsc/" \
		"${S}"/configure || die "sed failed"

	sed -i \
		"s#lib/libsc\.la#$(get_libdir)/libsc\.so#" \
		"${S}"/configure || die "sed failed"
}

src_configure() {
	# avoid underlinkage
	append-libs -lsc

	local myeconfargs=(
		--disable-static
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable openmp)
		$(use_enable romio mpiio)
		$(use_enable threads pthread)
		$(use_enable vtk-binary)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-sc="${ESYSROOT}/usr"
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

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
