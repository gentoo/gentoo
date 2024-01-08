# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=BertiniSource_v${PV}

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Software for Numerical Algebraic Geometry"
HOMEPAGE="http://bertini.nd.edu"
SRC_URI="https://bertini.nd.edu/${MYP}.tar.gz
	doc? ( https://bertini.nd.edu/BertiniUsersManual.pdf )"
S="${WORKDIR}"/${MYP/./}

LICENSE="bertini"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +optimization"

RDEPEND="
	dev-libs/gmp
	dev-libs/mpfr
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	app-alternatives/lex
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default

	# bug #723328
	append-cflags -fcommon

	# Ensure this is before the CFLAGS sed
	# or breakage occurs if 'gcc' is in your CFLAGS
	sed -i -e "s/gcc/$(tc-getCC)/" src/Makefile || die

	if ! use optimization ; then
		sed -i -e "s/\$(OPT)/ ${CFLAGS} ${CXXFLAGS} ${LDFLAGS}/" src/Makefile || die
	else
		# If people want the optimisation offered by upstream,
		# let's ensure they don't accidentally override it.
		filter-flags -O?
		sed -i -e "s/\$(OPT)/ \$(OPT) ${CFLAGS} ${LDFLAGS}/" src/Makefile || die
	fi
}

src_configure() {
	econf --prefix=/usr --includedir=/usr/include/${PN}

	use doc && DOCS+=( "${DISTDIR}"/BertiniUsersManual.pdf )
}

src_install() {
	emake DESTDIR="${D}" install

	find "${ED}" -name "*.la" -delete || die

	einstalldocs
}
