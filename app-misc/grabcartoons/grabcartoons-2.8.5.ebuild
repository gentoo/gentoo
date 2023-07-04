# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zzamboni/grabcartoons.git"
else
	SRC_URI="https://github.com/zzamboni/grabcartoons/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Comic-summarizing utility"
HOMEPAGE="https://zzamboni.org/code/grabcartoons/"

LICENSE="BSD"
SLOT="0"
# Opens a web page, which is unacceptable during an emerge.
RESTRICT="test"

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long"

PATCHES=( "${FILESDIR}"/${PV}-fix-install-paths.patch )

src_install() {
	emake PREFIX="${ED}"/usr install
	einstalldocs
}
