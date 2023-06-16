# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

PARTS_P="${PN}-parts-${PV}"
PARTS_COMMIT="667a5360e53e8951e5ca6c952ae928f7077a9d5e"

DESCRIPTION="Electronic Design Automation"
HOMEPAGE="
	https://fritzing.org/
	https://github.com/fritzing/fritzing-app/
"
SRC_URI="
	https://github.com/fritzing/fritzing-app/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fritzing/fritzing-parts/archive/${PARTS_COMMIT}.tar.gz -> ${PARTS_P}.tar.gz
"
S="${WORKDIR}/${PN}-app-${PV}"

LICENSE="CC-BY-SA-3.0 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/quazip:0=[qt5(+)]
	dev-libs/libgit2:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.4-move-parts-db-path.patch"
	"${FILESDIR}/${PN}-0.9.6-quazip-qt5.patch"
	"${FILESDIR}/${PN}-0.9.6-dropping-register-keyword.patch"
)

src_prepare() {
	default

	# Get a rid of the bundled libs
	# Bug 412555 and
	# https://code.google.com/p/fritzing/issues/detail?id=1898
	rm -r src/lib/quazip/ pri/quazip.pri || die

	# Use system libgit
	sed -i -e 's:LIBGIT_STATIC.*:LIBGIT_STATIC = false:' phoenix.pro || die

	# Add correct git version
	sed -i -e "s:GIT_VERSION = \$\$system.*$:GIT_VERSION = ${PV}:" pri/gitversion.pri || die
}

src_configure() {
	eqmake5 'DEFINES=QUAZIP_INSTALLED PARTS_COMMIT=\\\"'"${PARTS_COMMIT}"'\\\"' phoenix.pro
}

src_install() {
	PARTS_DIR="${WORKDIR}/fritzing-parts-${PARTS_COMMIT}"
	INSTALL_ROOT="${D}" default
	insinto /usr/share/fritzing/fritzing-parts
	doins -r ${PARTS_DIR}/*
	einstalldocs
}
