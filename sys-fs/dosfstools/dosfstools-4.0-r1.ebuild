# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools toolchain-funcs flag-o-matic

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="https://github.com/dosfstools/dosfstools"
SRC_URI="https://github.com/dosfstools/dosfstools/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="compat +udev"

CDEPEND="udev? ( virtual/libudev )"
DEPEND="${CDEPEND}
	udev? ( virtual/pkgconfig )"
RDEPEND="${CDEPEND}"

RESTRICT="test" # there is no test target #239071

PATCHES=(
	"${FILESDIR}/${P}-udevlibs.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable compat compat-symlinks) \
		$(use_with udev)
}

src_install() {
	default
	if ! use compat; then
		# Keep fsck -t vfat and mkfs -t vfat working, bug 584980.
		dosym fsck.fat /usr/sbin/fsck.vfat
		dosym mkfs.fat /usr/sbin/mkfs.vfat
	fi
}
