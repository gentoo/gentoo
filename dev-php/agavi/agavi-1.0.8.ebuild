# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PHP MVC application framework"
HOMEPAGE="http://www.agavi.org/"
SRC_URI="http://www.agavi.org/download/${PV}.tgz -> ${P}.tgz"
LICENSE="BSD LGPL-2.1+ icu unicode public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples +executable iconv session soap xmlrpc"

RDEPEND="dev-lang/php[iconv?,session?,soap?,xml,xmlrpc(-)?]
	executable? ( dev-php/phing )"

DOCS=(
	API_CHANGELOG
	CHANGELOG
	CHANGELOG-0.9
	CHANGELOG-0.10
	CHANGELOG-0.11
	CONTRIBUTING.md
	README.md
	RELEASE_NOTES
	RELEASE_NOTES-0.9
	RELEASE_NOTES-0.10
	RELEASE_NOTES-0.11
	UPGRADING
)

src_install() {
	einstalldocs
	use executable && newbin "${FILESDIR}/${PN}-executable" "${PN}"
	use examples && dodoc -r samples

	insinto "/usr/share/php/${PN}"
	doins -r src/*
}
