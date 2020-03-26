# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Customized version of Source Code Pro"
HOMEPAGE="https://github.com/nathco/Office-Code-Pro"
SRC_URI="https://github.com/nathco/Office-Code-Pro/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/Office-Code-Pro-${PV}"

FONT_SUFFIX="otf"

src_prepare() {
	default

	mv Fonts/*/OTF/*.otf . || die "Failed to move .otf files"
}
