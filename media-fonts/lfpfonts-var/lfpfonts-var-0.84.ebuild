# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font font-ebdftopcf

DESCRIPTION="Linux Font Project variable-width fonts"
HOMEPAGE="https://sourceforge.net/projects/xfonts/"
SRC_URI="mirror://sourceforge/xfonts/${PN}-src-${PV}.tar.bz2"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${PN}-src"

FONT_S="${S}/src"

DOCS="${S}/doc/*"

# Only installs fonts
RESTRICT="strip binchecks"
