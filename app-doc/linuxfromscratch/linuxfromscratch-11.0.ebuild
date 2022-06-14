# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_SRC="https://www.linuxfromscratch.org/lfs/downloads/${PV}"
BOOTSCRIPT_PV="20210608"

DESCRIPTION="LFS documents building a Linux system entirely from source"
HOMEPAGE="http://www.linuxfromscratch.org/lfs"
SRC_URI="${MY_SRC}/LFS-BOOK-${PV}.tar.xz
	${MY_SRC}/lfs-bootscripts-${BOOTSCRIPT_PV}.tar.xz
	${MY_SRC}-systemd/LFS-BOOK-${PV}.tar.bz2 -> LFS-BOOK-${PV}-systemd.tar.bz2
	htmlsingle? (
		${MY_SRC}/LFS-BOOK-${PV}-NOCHUNKS.html
		${MY_SRC}-systemd/LFS-BOOK-${PV}-NOCHUNKS.html -> LFS-BOOK-${PV}-systemd-NOCHUNKS.html
	)
	pdf? (
		${MY_SRC}/LFS-BOOK-${PV}.pdf
		${MY_SRC}-systemd/LFS-BOOK-${PV}-systemd.pdf
	)"
S="${WORKDIR}"

LICENSE="CC-BY-NC-SA-2.5 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="htmlsingle pdf"

src_unpack() {
	unpack lfs-bootscripts-${BOOTSCRIPT_PV}.tar.xz
	unpack LFS-BOOK-${PV}.tar.xz

	(
		mkdir -p "${S}"/systemd || die
		cd "${S}"/systemd || die
		unpack LFS-BOOK-${PV}-systemd.tar.bz2
	)

	if use htmlsingle; then
		cp "${DISTDIR}"/LFS-BOOK-${PV}{,-systemd}-NOCHUNKS.html "${S}" || die
	fi

	if use pdf; then
		cp "${DISTDIR}"/LFS-BOOK-${PV}{,-systemd}.pdf "${S}" || die
	fi
}

src_install() {
	dodoc -r *
	docompress -x /usr/share/doc/${PF}
}
