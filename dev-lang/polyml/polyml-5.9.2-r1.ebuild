# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a autotools

DESCRIPTION="Poly/ML is a full implementation of Standard ML"
HOMEPAGE="https://www.polyml.org/
	https://github.com/polyml/polyml/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="X +gmp portable"

RDEPEND="
	X? ( x11-libs/motif:0 )
	gmp? ( >=dev-libs/gmp-5:= )
	portable? ( dev-libs/libffi:= )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/polyml-5.9-c++11.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	lto-guarantee-fat

	local myconf=(
		--enable-shared
		--with-pic=pic-only
		$(use_enable !portable native-codegeneration)
		$(use_with X x)
		$(use_with gmp)
	)
	econf "${myconf[@]}"
}

src_test() {
	emake tests
}

src_install() {
	default
	strip-lto-bytecode

	if [[ -f "${ED}"/usr/$(get_libdir)/libpolymain.la ]] ; then
		rm "${ED}"/usr/$(get_libdir)/libpolymain.la || die
	fi

	if [[ -f "${ED}"/usr/$(get_libdir)/libpolyml.la ]] ; then
		rm "${ED}"/usr/$(get_libdir)/libpolyml.la || die
	fi
}
