# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
COMMIT=37dc6c67e2af26379d88ce349eb9c4c6160e8543
SRC_URI="https://github.com/niklasso/minisat/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="debug doc"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
DOCS=( README doc/ReleaseNotes-${PV%_*}.txt )
PATCHES=( "${FILESDIR}"/${P}-nusmv.patch )

src_prepare() {
	default
	# Remove makefile silencing and
	# Remove static linking by default
	sed -i -e "s/VERB=@/VERB=/" \
		-e "s/--static //g" \
		Makefile || die

	sed -i -e "s:\$(exec_prefix)/lib:\$(exec_prefix)/$(get_libdir):" \
		Makefile || die

	# Fix headers ( #include "minisat/..." -> #include <...> )
	while IFS="" read -d $'\0' -r file; do
		einfo Correcting header "$file"
		sed -i -e 's:#include "minisat/\([^"]*\)":#include <\1>:g' "${file}" || die
	done < <(find minisat -name "*.h" -print0)
}

src_configure() {
	local minisat_cflags="${CFLAGS} -D NDEBUG -I${S}/minisat"
	emake config prefix="${EPREFIX}"/usr MINISAT_RELSYM="" MINISAT_REL="${minisat_cflags}" MINISAT_PRF="${minisat_cflags}" MINISAT_DEB="${CFLAGS} -D DEBUG -I${S}/minisat"
}

src_compile() {
	emake all $(usex debug d "")
}

src_install() {
	use doc && DOCS+=( "${DISTDIR}"/MiniSat.pdf )
	default

	dosym libminisat.a /usr/$(get_libdir)/libMiniSat.a
}
