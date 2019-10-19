# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="un-fonts"
MY_PV="${PV/_pre/-}"

DESCRIPTION="Korean Un fonts extras collection"
HOMEPAGE="http://kldp.net/projects/unfonts/"
SRC_URI="mirror://gentoo/un-fonts-extra-${MY_PV}-r1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${MY_PN}"

FONT_SUFFIX="ttf"
FONT_S="${S}"
