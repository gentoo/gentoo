# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

DESCRIPTION="X.Org arabic bitmap fonts"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="x11-apps/bdftopcf"

DOCS=( README ChangeLog )

src_install() {
	einstalldocs
	xorg-3_src_install
}
