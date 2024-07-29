# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A set of default and supplemental wallpapers for Fedora"
HOMEPAGE="https://github.com/fedoradesign/backgrounds"

MY_PN="f$(ver_cut 1)-backgrounds"
MY_P="${MY_PN}-${PV}"
SRC_URI="https://github.com/fedoradesign/backgrounds/releases/download/v${PV}/${MY_P}.tar.xz"

# Review on each bump, files Attribution*
LICENSE="CC-BY-SA-4.0"

KEYWORDS="amd64 x86"
SLOT="$(ver_cut 1)"

S="${WORKDIR}/${MY_PN}"

src_install() {
	default
	# Don't change default MATE background
	rm "${ED}"/usr/share/backgrounds/mate/default.xml || die
}
