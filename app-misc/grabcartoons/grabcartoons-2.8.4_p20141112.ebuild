# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

DESCRIPTION="Comic-summarizing utility"
HOMEPAGE="http://zzamboni.org/grabcartoons"

EGIT_REPO_URI="https://github.com/zzamboni/grabcartoons.git"

if [[ "${PV}" != "9999" ]] ; then
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="cb230f01fb288a0b9f0fc437545b97d06c846bd3"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"

# Opens a web page, which is unacceptable during an emerge.
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/2.8.4-fix-install-paths.patch
}

src_install() {
	emake PREFIX="${ED}"/usr install
	dodoc ChangeLog README
}
