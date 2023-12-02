# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Header-only implementation of a typed linked list in C"
HOMEPAGE="https://codeberg.org/dnkl/tllist"
SRC_URI="https://codeberg.org/dnkl/tllist/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_install() {
	meson_src_install

	rm -r "${ED}/usr/share/doc/${PN}" || die
}
