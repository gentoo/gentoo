# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="static-libs lzma lz4"

DEPEND="lzma? ( app-arch/xz-utils )
	lz4? ( app-arch/lz4 )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	MAKE_OPTS=(
		CC="$(tc-getCC)"
		AR="$(tc-getAR)"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)

	PTARGET="zstd"

	if use lzma ; then
		PTARGET="xzstd"
	fi

	if use lz4 ; then
		PTARGET="zstd4"
	fi

	if use lzma && use lz4 ; then
		PTARGET="xzstd4"
	fi
}

src_compile() {
	emake -C programs "${MAKE_OPTS}" "${PTARGET}"
	emake -C lib "${MAKE_OPTS}" libzstd
}

src_install() {
	emake "${MAKE_OPTS}"\
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	einstalldocs

	if ! use static-libs; then
		rm "${ED%/}"/usr/$(get_libdir)/libzstd.a || die
	fi
}
