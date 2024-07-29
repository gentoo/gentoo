# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GPG keyring maintenance using changesets"
HOMEPAGE="http://joeyh.name/code/jetring/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="app-crypt/gnupg"
RDEPEND="
	${DEPEND}
	dev-lang/perl
	"

PATCHES=(
	"${FILESDIR}"/${PN}-0.21-parallel.patch
)

src_compile() {
	addpredict "/run/user/$(id -u)/gnupg/"
	default
}

src_install() {
	default

	insinto /usr/share/${PN}/
	doins -r example

	doman ${PN}*.[0-9]
}
