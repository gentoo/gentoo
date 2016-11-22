# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate-desktop.org

if [[ ${PV} == 9999 ]]; then
	inherit autotools
else
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Common files for development of MATE packages"
LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	default
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

src_install() {
	mv doc-build/README README.doc-build \
		|| die "Failed to rename doc-build/README."

	default

	dodoc doc/usage.txt
}
