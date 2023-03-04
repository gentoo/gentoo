# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 20220303 ]] && COMMIT=99d707bc3c600a9d6052a46a7c85f05b74c589a2

DESCRIPTION="Sample databases for Metamath"
HOMEPAGE="http://us.metamath.org/mpeuni/mmset.html
	https://github.com/metamath/set.mm/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metamath/set.mm.git"
else
	SRC_URI="https://github.com/metamath/set.mm/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/set.mm-${COMMIT}
fi

LICENSE="CC0-1.0"
SLOT="0"
IUSE="doc"

RDEPEND="sci-mathematics/metamath"

DOCS=(
	CONTRIBUTING.md README.md
	discouraged iset-discouraged
	mmnotes.txt
	other-databases.md verifiers.md
)

src_install() {
	insinto /usr/share/metamath
	doins *.mm *.mmts

	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r people
		dodoc *.html *.svg
	fi
}
