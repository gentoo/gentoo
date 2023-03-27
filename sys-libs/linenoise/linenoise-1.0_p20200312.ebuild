# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A small self-contained alternative to readline and libedit"
HOMEPAGE="https://github.com/antirez/linenoise"
COMMIT="97d2850af13c339369093b78abe5265845d78220"
SRC_URI="https://github.com/antirez/linenoise/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # linenoise does not have any tests

src_configure() {
	cp ${FILESDIR}/meson.build . || die
	meson_src_configure
}
