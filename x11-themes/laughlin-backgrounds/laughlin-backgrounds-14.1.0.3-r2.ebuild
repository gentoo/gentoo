# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

MY_P="${PN}-$(ver_cut 1-3)"

DESCRIPTION="Fedora 14 official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F14_Artwork"
SRC_URI="https://archives.fedoraproject.org/pub/archive/fedora/linux/development/15/source/SRPMS/${PN}-$(ver_rs 3 -).fc15.src.rpm"
S="${WORKDIR}/${MY_P}"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

src_unpack() {
	rpm_src_unpack

	# as of 2017-07-28 rpm.eclass does not unpack the further lzma
	# file automatically.
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }

src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install
}
