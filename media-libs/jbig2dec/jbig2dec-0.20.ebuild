# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools python-any-r1

DESCRIPTION="A decoder implementation of the JBIG2 image compression format"
HOMEPAGE="https://jbig2dec.com/"
SRC_URI="
	https://github.com/ArtifexSoftware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://jbig2dec.sourceforge.net/ubc/jb2streams.zip )
"

LICENSE="AGPL-3"
SLOT="0/$(ver_cut 1-2)" #698428
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="png static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/unzip
		${PYTHON_DEPS}
	)
"
RDEPEND="png? ( media-libs/libpng:= )"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	if use test; then
		mkdir "${WORKDIR}/ubc" || die
		mv -v "${WORKDIR}"/*.jb2 "${WORKDIR}/ubc/" || die
		mv -v "${WORKDIR}"/*.bmp "${WORKDIR}/ubc/" || die
	fi

	# We only need configure.ac and config_types.h.in
	sed -i \
		-e '/^# do we need automake?/,/^autoheader/d' \
		-e '/echo "  $AUTOM.*/,$d' \
		autogen.sh \
		|| die "failed to modify autogen.sh"

	./autogen.sh || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with png libpng)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm {} + || die
}
