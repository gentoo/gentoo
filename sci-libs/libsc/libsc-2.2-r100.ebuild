# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} )

inherit autotools lua-single toolchain-funcs eutils

DESCRIPTION="Support for parallel scientific applications"
HOMEPAGE="http://www.p4est.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cburstedde/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
else
	SRC_URI="https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="debug examples mpi openmp romio static-libs threads"

REQUIRED_USE="${LUA_REQUIRED_USE}
	romio? ( mpi )"

RDEPEND="${LUA_DEPS}
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-autoconf_lua_version.patch
)

DOCS=( AUTHORS NEWS README )

AUTOTOOLS_AUTORECONF=true

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && use openmp; then
		tc-has-openmp || \
			die "Please select an openmp capable compiler like gcc[openmp]"
	fi
}

src_prepare() {
	default

	sed -i -e "s/@LUA_IMPL@/${ELUA}/" "${S}"/src/sc_lua.h || die

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable openmp openmp)
		$(use_enable romio mpiio)
		$(use_enable static-libs static)
		$(use_enable threads pthread)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	econf LUA_IMPL="${ELUA}" "${myeconfargs[@]}"
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc -r example/*
		docompress -x /usr/share/doc/${PF}/examples
	else
		# Remove compiled example binaries in case of -examples:
		rm -r "${ED}"/usr/bin || die "rm failed"
	fi

	# Remove ac files, bug #619806
	rm -r "${ED}"/usr/share/aclocal || die "rm failed"

	# Fix wrong installation paths:
	dodir /usr/share/libsc
	mv "${ED}"/etc/* "${ED}"/usr/share/libsc || die "mv failed"
	rmdir "${ED}"/etc/ || die "rmdir failed"
	mv "${ED}"/usr/share/ini/* "${ED}"/usr/share/libsc || die "mv failed"
	rmdir "${ED}"/usr/share/ini || die "rmdir failed"
}
