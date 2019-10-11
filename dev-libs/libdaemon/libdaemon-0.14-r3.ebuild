# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Simple library for creating daemon processes in C"
HOMEPAGE="http://0pointer.de/lennart/projects/libdaemon/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PV}-man-page-typo-fix.patch
)

src_prepare() {
	default

	# doxygen is broken with out-of-source builds
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir=/var \
		--disable-examples \
		--disable-lynx \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use doc; then
		einfo "Building documentation"
		emake doxygen
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r doc/README.html doc/style.css doc/reference/html/*
		doman doc/reference/man/man3/*.h.3
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc examples/testd.c
	fi
}
