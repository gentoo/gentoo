# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Dman95/SASM.git"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://github.com/Dman95/SASM/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/SASM-${PV}"
fi

DESCRIPTION="Simple crossplatform IDE for NASM assembly language"
HOMEPAGE="http://dman95.github.io/SASM/"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-unbundle-qtsingleapplication.patch
)

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsingleapplication
	dev-qt/qtwidgets:5
"
REPEND="${DEPEND}
	dev-lang/nasm
	sys-devel/gdb
"

# SASM repository contains precompiled binaries ¯\_(ツ)_/¯
QA_PREBUILT="usr/bin/fasm usr/bin/listing"

src_prepare() {
	# To recompress it with gentoo tools
	gunzip Linux/share/doc/sasm/changelog.gz || die
	sed -e 's@changelog.gz@changelog@g' \
		-e '/docfiles.path/s@doc/sasm@doc/'${PF}'@g' \
		-i SASM.pro || die

	default
}

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
