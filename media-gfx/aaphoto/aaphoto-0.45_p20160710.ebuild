# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

GIT_COMMIT="ad4fc3c04b9e25212d78c231e1507458dfea8909"

DESCRIPTION="Automatic color correction and resizing of photos"
HOMEPAGE="https://web.archive.org/web/20220728233436/http://log69.com/aaphoto_en.html https://github.com/log69/aaphoto"
SRC_URI="https://github.com/log69/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}
