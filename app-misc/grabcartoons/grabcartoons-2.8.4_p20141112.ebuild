# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zzamboni/grabcartoons.git"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/zzamboni/grabcartoons/archive/cb230f01fb288a0b9f0fc437545b97d06c846bd3.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Comic-summarizing utility"
HOMEPAGE="https://zzamboni.org/code/grabcartoons/"

LICENSE="BSD"
SLOT="0"
IUSE=""
# Opens a web page, which is unacceptable during an emerge.
RESTRICT="test"

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long"

PATCHES=( "${FILESDIR}"/2.8.4-fix-install-paths.patch )

src_install() {
	emake PREFIX="${ED%/}"/usr install
	einstalldocs
}
