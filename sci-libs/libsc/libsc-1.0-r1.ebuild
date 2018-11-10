# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Support for parallel scientific applications"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples mpi romio static-libs"

REQUIRED_USE="romio? ( mpi )"

RDEPEND="
	dev-lang/lua:*
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable romio mpiio)
		$(use_enable static-libs static)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	econf "${myeconfargs[@]}"
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
}
