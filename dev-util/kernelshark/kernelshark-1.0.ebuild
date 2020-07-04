# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic cmake-utils

DESCRIPTION="Graphical reader for trace-cmd output"
HOMEPAGE="https://kernelshark.org/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="https://github.com/rostedt/trace-cmd.git"
	inherit git-r3
	S="${WORKDIR}/${P}/kernel-shark"

else
	MY_P="${PN}-v${PV}"
	SRC_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-${MY_P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/trace-cmd-${MY_P}/kernel-shark"

fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="custom-optimization doc"

DEPEND=">=dev-util/trace-cmd-2.8.3:=
	dev-libs/json-c:=
	>=media-libs/freeglut-3.0.0:=
	x11-libs/libXmu:=
	x11-libs/libXi:=
	dev-qt/qtcore:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtnetwork:5=
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-util/cmake-2.8.11
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
	)
"

PATCHES=(
	"${FILESDIR}/kernelshark-1.0-build.patch"
	"${FILESDIR}/kernelshark-1.0-desktop-version.patch"
)

src_configure() {
	local mycmakeargs=(
		-D_INSTALL_PREFIX="${EPREFIX}/usr"
		-DTRACECMD_INCLUDE_DIR="${EPREFIX}/usr/include/trace-cmd"
		-D_DOXYGEN_DOC="$(usex doc)"
	)
	use custom-optimization || replace-flags -O? -O3
	cmake-utils_src_configure
}
