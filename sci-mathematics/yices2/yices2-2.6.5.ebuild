# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="SMT Solver supporting SMT-LIB and Yices specification language"
HOMEPAGE="https://github.com/SRI-CSL/yices2/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/SRI-CSL/${PN}"
else
	SRC_URI="https://github.com/SRI-CSL/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0/${PV}"
IUSE="+mcsat"

RDEPEND="
	dev-libs/gmp:=
	mcsat? (
		sci-mathematics/libpoly:=
		sci-mathematics/cudd:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-process/parallel
"

DOCS=( FAQ.md README.md )

src_prepare() {
	mkdir "${HOME}/.parallel" || die
	touch "${HOME}/.parallel/will-cite" || die "parallel setup failed"

	default
	eautoreconf
}

src_configure() {
	econf $(use_enable mcsat)
}

src_compile() {
	emake STRIP="echo"
}

src_test() {
	emake check
}

src_install() {
	default

	doman ./doc/*.1

	rm "${ED}/usr/$(get_libdir)/libyices.a" || die
}
