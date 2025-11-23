# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A tool which replaces copies of a file with hardlinks"
HOMEPAGE="https://jak-linux.org/projects/hardlink/"
#SRC_URI="https://jak-linux.org/projects/${PN}/${PN}_${PV}.tar.xz"
SRC_URI="https://salsa.debian.org/jak/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"

RDEPEND="
	dev-libs/libpcre
	!>=sys-apps/util-linux-2.34[hardlink]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README "${T}"/README.rsync )

src_prepare() {
	default
	sed -i -e '/^CF/s:?=:+=:' -e '/^CF/s:-O2 -g::' Makefile || die

	cat <<-EOF > "${T}"/README.rsync
	https://hardlinkpy.googlecode.com/svn/trunk/hardlink.py has regex '^\..*\.\?{6,6}$'
	for excluding rsync temporary files by default.

	To accomplish same with this version, you can use following syntax:
	# hardlink -x '^\..*\.\?{6,6}$'

	This was discussed at https://bugs.gentoo.org/416613
	EOF
}

src_compile() {
	emake CC="$(tc-getCC)"
}
