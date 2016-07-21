# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Script to do \"scrubbing\" on software RAID systems"
HOMEPAGE="https://github.com/fukawi2/raid-check"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-path.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_compile() { :; }

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" D_BIN=/usr/sbin install
}
