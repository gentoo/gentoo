# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Mathematical Components for the Coq proof assistant"
HOMEPAGE="https://github.com/math-comp/math-comp/"
SRC_URI="https://github.com/math-comp/math-comp/archive/mathcomp-${PV}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}"/math-comp-mathcomp-${PV}/mathcomp

LICENSE="CeCILL-B"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND=">=sci-mathematics/coq-8.13.0:= <sci-mathematics/coq-8.16.0:="
DEPEND="${RDEPEND}"

# > make jobserver unavailable
src_compile() {
	emake -j1
}

src_install() {
	emake -j1 install DESTDIR="${D}"
}
