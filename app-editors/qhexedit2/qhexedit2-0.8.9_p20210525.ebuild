# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )

#DISTUTILS_OPTIONAL=1
#DISTUTILS_USE_PEP517=p

inherit distutils-r1 qmake-utils

EGIT_COMMIT="541139125be034b90b6811a84faa1413e357fd94"
DESCRIPTION="Hex editor library, Qt application written in C++ with Python bindings"
HOMEPAGE="https://github.com/Simsys/qhexedit2/"
SRC_URI="https://github.com/Simsys/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc +gui python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=( "${FILESDIR}/${PN}-0.8.9.patch" )

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	python? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
		)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_configure() {
	eqmake5 src/qhexedit.pro
	if use gui; then
		cd example || die "can't cd example"
		eqmake5 qhexedit.pro
	fi
}

src_compile() {
	default
	use python && distutils-r1_src_compile
	use gui && emake -C example
}

python_compile() {
	use python && distutils-r1_python_compile build_ext
}

src_test() {
	cd test || die "can't cd test"
	mkdir logs || die "can't create logs dir"
	eqmake5 chunks.pro
	emake
	./chunks || die "test run failed"
	grep -q "^NOK" logs/Summary.log && die "test failed"
}

src_install() {
	doheader src/*.h
	dolib.so libqhexedit.so*
	use python && distutils-r1_src_install
	if use gui; then
		dobin example/qhexedit
		insinto /usr/share/${PN}/
		doins example/translations/*.qm
	fi
	if use doc; then
		dodoc -r doc/html
		dodoc doc/release.txt
	fi
}
