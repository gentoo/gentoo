# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Comic-summarizing utility"
HOMEPAGE="http://zzamboni.org/grabcartoons"
EGIT_COMMIT="cb230f01fb288a0b9f0fc437545b97d06c846bd3"
SRC_URI="https://github.com/zzamboni/grabcartoons/archive/cb230f01fb288a0b9f0fc437545b97d06c846bd3.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long"

# Opens a web page, which is unacceptable during an emerge.
RESTRICT="test"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=(
	"${FILESDIR}"/2.8.4-fix-install-paths.patch
	)

src_install() {
	emake PREFIX="${ED}"usr install
	dodoc ChangeLog README
}
