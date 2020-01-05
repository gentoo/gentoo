# Copyright 2017-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

DISTUTILS_OPTIONAL=1

inherit distutils-r1 qmake-utils

DESCRIPTION="Hex editor library, Qt application written in C++ with Python bindings"
HOMEPAGE="https://github.com/lancos/qhexedit2/"
SRC_URI="https://github.com/lancos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gui python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${P}-fixtest.patch"
	"${FILESDIR}/${P}-setup.py.patch"
)

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	python? ( dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
			dev-python/sip[${PYTHON_USEDEP}]
			${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e '/^unix:DESTDIR/ d' -e "\$atarget.path = /usr/$(get_libdir)" \
		-e "\$aINSTALLS += target" src/qhexedit.pro \
		|| die "src/qhexedit.pro: sed failed"
	use python && distutils-r1_src_prepare
}

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
	if use gui; then
		cd example || die "can't cd example"
		emake
	fi
}

python_compile() {
	use python && distutils-r1_python_compile build_ext --library-dirs="${S}"
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
	emake INSTALL_ROOT="${D}" install
	use python && distutils-r1_src_install
	use gui && dobin example/qhexedit
	if use doc; then
		dodoc -r doc/html
		dodoc doc/release.txt
	fi
}
