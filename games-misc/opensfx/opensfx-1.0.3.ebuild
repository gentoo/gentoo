# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenSFX data files for OpenTTD"
HOMEPAGE="https://wiki.openttd.org/en/Basesets/OpenSFX https://github.com/OpenTTD/OpenSFX"
SRC_URI="https://cdn.openttd.org/opensfx-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}"/${P}-source

LICENSE="CC-BY-SA-3.0 CDDL-1.1 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="games-util/catcodec"

src_install() {
	emake INSTALL_DIR="${ED}/usr/share/openttd/baseset/" install
	dodoc docs/{changelog.txt,readme.ptxt}
}
