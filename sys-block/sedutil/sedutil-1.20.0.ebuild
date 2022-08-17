# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The Drive Trust Alliance Self Encrypting Drive Utility"
HOMEPAGE="https://github.com/Drive-Trust-Alliance/sedutil"
SRC_URI="https://github.com/Drive-Trust-Alliance/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

src_prepare() {
	default
	# https://github.com/Drive-Trust-Alliance/sedutil/pull/49
	sed 's: -Werror: :g' \
		-i configure.ac \
		-i Makefile.am || die
	eautoreconf
}
