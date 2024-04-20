# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Find duplicate files based on their content"
HOMEPAGE="https://github.com/pauldreik/rdfind"
SRC_URI="https://github.com/pauldreik/rdfind/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-releases-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/nettle:="
DEPEND="${RDEPEND}"
BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0_include-limits-header.patch"
	"${FILESDIR}/${PN}-1.5.0-configure-nettle.patch"
	"${FILESDIR}/${PN}-1.5.0-gcc-13.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_test() {
	# Bug 840544
	local -x SANDBOX_PREDICT="${SANDBOX_PREDICT}"
	addpredict /
	default
}
