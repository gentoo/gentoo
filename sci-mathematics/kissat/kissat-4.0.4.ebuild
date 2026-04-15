# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

DESCRIPTION="Keep-it-simple and clean bare metal SAT solver written in C"
HOMEPAGE="http://fmv.jku.at/kissat/
	https://github.com/arminbiere/kissat/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/arminbiere/${PN}"
else
	SRC_URI="https://github.com/arminbiere/${PN}/archive/rel-${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-rel-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	!>=x11-terms/kitty-0.27
"

DOCS=( CONTRIBUTING NEWS.md README.md )

src_configure() {
	local myopts=(
		CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
		--kitten
		--statistics
	)
	sh ./configure "${myopts[@]}" || die
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	dobin build/{kissat,kitten}
	einstalldocs
}
