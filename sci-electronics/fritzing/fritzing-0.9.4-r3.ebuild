# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

MY_PV="CD-498"
PARTS_P="${PN}-parts-${PV}"
PARTS_COMMIT="e79a69765026f3fda8aab1b3e7a4952c28047a62"

DESCRIPTION="Electronic Design Automation"
HOMEPAGE="https://fritzing.org/
	https://github.com/fritzing/fritzing-app/"
SRC_URI="https://github.com/fritzing/fritzing-app/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fritzing/fritzing-parts/archive/${PARTS_COMMIT}.tar.gz -> ${PARTS_P}.tar.gz"

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

S="${WORKDIR}/${PN}-app-${MY_PV}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-libgit2-version.patch"
	"${FILESDIR}/${P}-move-parts-db-path.patch"
	"${FILESDIR}/${P}-quazip1.patch"
)

src_prepare() {
	xdg_src_prepare

	if has_version "<dev-libs/quazip-1.0"; then
		sed -e "/PKGCONFIG/s/quazip1-qt5/quazip/" -i phoenix.pro || die
	fi

	# Get a rid of the bundled libs
	# Bug 412555 and
	# https://code.google.com/p/fritzing/issues/detail?id=1898
	rm -r src/lib/quazip/ pri/quazip.pri || die

	# Fritzing doesn't need zlib
	sed -i -e 's:LIBS += -lz::' -e 's:-lminizip::' phoenix.pro || die

	# Use system libgit
	sed -i -e 's:LIBGIT_STATIC.*:LIBGIT_STATIC = false:' phoenix.pro || die

	# Add correct git version
	sed -i -e "s:GIT_VERSION = \$\$system.*$:GIT_VERSION = ${MY_PV}:" pri/gitversion.pri || die
}

src_configure() {
	eqmake5 'DEFINES=QUAZIP_INSTALLED PARTS_COMMIT=\\\"'"${PARTS_COMMIT}"'\\\"' phoenix.pro
}

src_install() {
	PARTS_DIR="${WORKDIR}/fritzing-parts-${PARTS_COMMIT}"
	INSTALL_ROOT="${D}" default
	insinto /usr/share/fritzing/fritzing-parts
	doins -r ${PARTS_DIR}/*
}
