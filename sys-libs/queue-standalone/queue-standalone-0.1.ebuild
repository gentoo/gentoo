# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Install <sys/queue.h> from glibc."
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}"

src_install() {
	mkdir -p "${D}"/usr/include/sys
	cp "${FILESDIR}"/queue.h "${D}"/usr/include/sys
}
