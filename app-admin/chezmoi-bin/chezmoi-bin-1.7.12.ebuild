# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage your dotfiles across multiple machines, securely."
HOMEPAGE="https://github.com/twpayne/chezmoi"

# Remove bin from the package name
BASE_PN="${PN/-bin}"
A_AMD64="${P}_amd64.tar.gz"
A_X86="${P}_x86.tar.gz"

BASE_URI="${HOMEPAGE}/releases/download/v${PV}/${BASE_PN}_${PV}_linux"
SRC_URI="amd64? ( ${BASE_URI}_amd64.tar.gz -> ${A_AMD64} )
	x86? ( ${BASE_URI}_i386.tar.gz -> ${A_X86} )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( "docs" )

src_unpack() {
	# Create the source directory
	mkdir -p "${S}" || die
	pushd "${S}" || die

	# Determine the correct source package
	if use x86; then
		ARCHIVE="${A_X86}"
	elif use amd64; then
		ARCHIVE="${A_AMD64}"
	fi

	# Unpack the archive if a matching one was found
	if [ "${ARCHIVE}" != "" ]; then
		unpack ${ARCHIVE}
	fi
}

src_install() {
	einstalldocs
	dobin "${S}/${BASE_PN}" || die
}
