# Copyright 1999-2022 Gentoo Authors
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
BDEPEND="sys-devel/autoconf-archive"

PATCHES=( "${FILESDIR}/${PN}-1.5.0_include-limits-header.patch" )

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
