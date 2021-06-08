# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools prefix

MY_PV=$(ver_cut 1-2)
# 11.2_p8_p1 -> 11.2-8.1
MY_DEB_PV="${MY_PV}-$(ver_cut 4).$(ver_cut 6)"

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://sjeng.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/sjeng/Sjeng-Free-${MY_PV}.tar.gz
	mirror://debian/pool/main/s/sjeng/sjeng_${MY_DEB_PV}.diff.gz
"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="sys-libs/gdbm:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/Sjeng-Free-${MY_PV}"

PATCHES=(
	"${WORKDIR}/sjeng_${MY_DEB_PV}.diff"
	"${S}/debian/patches"
)

src_prepare() {
	default

	hprefixify book.c rcfile.c

	# Files generated with ancient autotools, regenerate to respect CC.
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	insinto /etc
	doins sjeng.rc

	insinto /usr/share/games/sjeng
	doins books/*.opn
}
