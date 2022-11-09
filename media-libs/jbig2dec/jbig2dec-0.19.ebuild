# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-any-r1

DESCRIPTION="A decoder implementation of the JBIG2 image compression format"
HOMEPAGE="https://jbig2dec.com/"
SRC_URI="https://github.com/ArtifexSoftware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( http://jbig2dec.sourceforge.net/ubc/jb2streams.zip )"

LICENSE="AGPL-3"
SLOT="0/$(ver_cut 1-2)" #698428
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="png static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/unzip
		${PYTHON_DEPS}
	)
"

RDEPEND="png? ( media-libs/libpng:0= )"
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
