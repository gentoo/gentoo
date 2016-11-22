# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

COMMIT_ID="e412923f1f792408e8ae1096ca40fb5307ddfc74"
DESCRIPTION="Generate waveformjs.org compatible json data out of wav files"
HOMEPAGE="https://github.com/beschulz/wav2json"
SRC_URI="https://github.com/beschulz/wav2json/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/${PN}-${COMMIT_ID}/build

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/boost:=
	media-libs/libsndfile
"
RDEPEND="${DEPEND}"

src_install() {
	dobin ../bin/Linux/wav2json
}
