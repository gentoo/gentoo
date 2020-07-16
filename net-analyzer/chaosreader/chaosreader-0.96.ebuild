# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Trace TCP/UDP/... sessions and fetch application data."
HOMEPAGE="http://chaosreader.sourceforge.net
	https://github.com/brendangregg/Chaosreader"
SRC_URI="https://github.com/brendangregg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"

KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="GPL-2+"

DEPEND=">=dev-lang/perl-5.8.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Chaosreader-${PV}"

PATCHES=(
	"${FILESDIR}"/chaosreader-0.96-zombies.patch
	"${FILESDIR}"/chaosreader-0.96-chunkcheck.patch
	"${FILESDIR}"/chaosreader-0.96-divisionbyzero.patch
)

src_install() {
	dobin ${PN}
}
