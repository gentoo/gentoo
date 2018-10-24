# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMITHASH="abc8fca7499f44c725122881cd380a88c37abe0e"

DESCRIPTION="Arduino private fork of dev-util/ctags"
HOMEPAGE="https://github.com/arduino/ctags"
SRC_URI="https://github.com/arduino/ctags/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/ctags-${COMMITHASH}"

src_configure() {
	econf \
		--disable-readlib \
		--disable-etags \
		--enable-tmpdir="${EPREFIX}"/tmp
}

src_install() {
	# This package compiles into a "ctags" executable, but don't want to clash into
	# actually legitimate ctags implementations.
	mv ctags arduino-ctags
	dobin arduino-ctags
}
