# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A message sequence chart generator"
HOMEPAGE="http://www.mcternan.me.uk/mscgen/"
SRC_URI="http://www.mcternan.me.uk/${PN}/software/${PN}-src-${PV}.tar.gz"

KEYWORDS="amd64 arm ppc ppc64 x86 ~x64-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="png truetype"
REQUIRED_USE="truetype? ( png )"

RDEPEND="
	truetype? ( media-libs/freetype )
	png? ( media-libs/gd[png,truetype?] )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

# Workaround for bug #379279
RESTRICT="test"

src_prepare() {
	sed -i -e '/dist_doc_DATA/d' Makefile.am || die "Fixing Makefile.am failed"
	eautoreconf
	eapply_user
}

src_configure() {
	local myconf

	if use png; then
		use truetype && myconf="--with-freetype"
	else
		myconf="--without-png"
	fi

	econf ${myconf}
}
