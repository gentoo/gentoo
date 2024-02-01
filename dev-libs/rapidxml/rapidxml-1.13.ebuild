# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix

DESCRIPTION="An attempt to create the fastest XML parser possible"
HOMEPAGE="https://sourceforge.net/projects/rapidxml/"

SRC_URI="mirror://sourceforge/${PN}/${P}-with-tests.zip -> ${P}.zip"

S=${WORKDIR}/${P}-with-tests

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/unzip
	app-text/dos2unix
	test? (
		dev-libs/pugixml
		dev-libs/tinyxml
	)
"

DOCS=( manual.html license.txt )

PATCHES=(
	"${FILESDIR}"/"${P}"-clang-declarations.patch
	"${FILESDIR}"/"${P}"-fix-tests.patch
)

src_prepare() {
	local convert=$(find "${S}" -type f || die )
	local item
	for item in ${convert[@]} ; do
		edos2unix "${item}" || die "Could not convert line endings"
	done

	default
}

src_test() {
	cd tests || die
	emake run-g++-debug
}

src_install() {
	doheader *.hpp
	einstalldocs
}
