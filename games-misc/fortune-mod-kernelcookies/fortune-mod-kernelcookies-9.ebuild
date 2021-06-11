# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of funny lines from the Linux kernel"
HOMEPAGE="http://www.schwarzvogel.de/software-misc.shtml"
SRC_URI="http://www.schwarzvogel.de/pkgs/kernelcookies-${PV}.tar.gz"
S="${WORKDIR}"/kernelcookies-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="offensive"

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# bug #64985
	if ! use offensive ; then
		rm -f *.dat || die
		eapply "${FILESDIR}"/${PV}-offensive.patch
		strfile -s kernelcookies || die
	fi
}

src_install() {
	insinto /usr/share/fortune
	doins kernelcookies.dat kernelcookies
}
