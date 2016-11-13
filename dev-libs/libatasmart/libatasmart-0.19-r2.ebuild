# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

PATCH_LEVEL=2

DESCRIPTION="A small and lightweight parser library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="http://0pointer.de/blog/projects/being-smart.html"
SRC_URI="http://0pointer.de/public/${P}.tar.xz
	mirror://debian/pool/main/liba/${PN}/${PN}_${PV}-${PATCH_LEVEL}.debian.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="static-libs"

RDEPEND="virtual/libudev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# https://bugs.gentoo.org/470874
	local d="${WORKDIR}"/debian/patches
	sed -i -e '/#/d' \
		-e "s|^|${d}/|" "${d}"/series || die
	eapply $(<"${d}"/series)
	eapply_user
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
