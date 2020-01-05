# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="noVNC is a VNC client implemented using HTML5 technologies"
HOMEPAGE="https://kanaka.github.com/noVNC/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kanaka/noVNC.git"
else
	SRC_URI="https://github.com/kanaka/noVNC/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
fi

S="${WORKDIR}/noVNC-${PV}"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/websockify[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"

python_compile() {
	echo
}

src_install() {
	exeinto /usr/share/novnc/utils
	for f in utils/*; do
		[[ ! f = utils/README.md ]] && doexe $f
	done

	dodoc README.md LICENSE.txt

	insinto /usr/share/novnc
	doins -r vnc.html vnc_lite.html app/ core/ vendor/
	dosym /usr/share/novnc/vnc_lite.html /usr/share/novnc/vnc_auto.html  # for compat
}
