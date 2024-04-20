# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-r1 qmake-utils

EGIT_COMMIT="541139125be034b90b6811a84faa1413e357fd94"
DESCRIPTION="Hex editor library, Qt application written in C++ with Python bindings"
HOMEPAGE="https://github.com/Simsys/qhexedit2/"
SRC_URI="https://github.com/Simsys/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="doc +gui python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.4-setup.py.patch"
	"${FILESDIR}/${PN}-0.8.6-sip.patch" #820473
	"${FILESDIR}/${PN}-0.8.6-sip5.patch" #820473
	"${FILESDIR}/${PN}-0.8.9-fix-crash.patch"
)

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/PyQt5-5.15.6[gui,widgets,${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
			>=dev-python/sip-5:=[${PYTHON_USEDEP}]
		')
	)
"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	sed -i -e '/^unix:DESTDIR/ d' -e "\$atarget.path = /usr/$(get_libdir)" \
		-e "\$aINSTALLS += target" src/qhexedit.pro \
		|| die "src/qhexedit.pro: sed failed"
}

src_configure() {
	eqmake5 src/qhexedit.pro
	if use gui; then
		cd example || die "can't cd example"
		eqmake5 qhexedit.pro
	fi
}

src_compile() {
	emake
	use gui && emake -C example
	if use python; then
		export PATH="$(qt5_get_bindir):${PATH}"
		python_build() {
			pushd "${S}" || die
			sip-build || die
			popd || die
		}
		python_foreach_impl run_in_build_dir python_build
	fi
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
	if use python; then
		python_install() {
			pushd "${S}"/build || die
			emake INSTALL_ROOT="${D}" install
			popd || die
		}
		python_foreach_impl run_in_build_dir python_install
	fi
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
