# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Install <sys/queue.h> from glibc."
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 x86"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}"

src_install() {
	insinto /usr/include/sys
	doins "${FILESDIR}"/queue.h
}
