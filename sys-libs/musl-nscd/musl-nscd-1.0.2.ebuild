# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles

DESCRIPTION="musl-nscd is an implementation of the NSCD protocol for the musl libc"
HOMEPAGE="https://github.com/pikhq/musl-nscd"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pikhq/musl-nscd"
	EGIT_BRANCH=master
else
	SRC_URI="https://github.com/pikhq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="minimal"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default

	sed -i '/LDFLAGS_AUTO=-s/d' configure || die 'Cannot patch configure file'
}

src_install() {
	if use minimal; then
		emake DESTDIR="${D}" install-headers
	else
		emake DESTDIR="${D}" install

		newinitd "${FILESDIR}"/nscd.initd nscd
		systemd_dounit "${FILESDIR}"/nscd.service
		newtmpfiles "${FILESDIR}"/nscd.tmpfilesd nscd.conf

		dodoc README
	fi
}
