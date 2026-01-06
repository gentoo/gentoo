# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1 qmake-utils

DESCRIPTION="Hex editor library, Qt application written in C++ with Python bindings"
HOMEPAGE="https://github.com/Simsys/qhexedit2/"
SRC_URI="https://github.com/Simsys/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc +gui python"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	media-libs/libglvnd
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pyqt6-6.8.0[gui,widgets,${PYTHON_USEDEP}]
			>=dev-python/pyqt6-sip-13.5:=[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/pyqt-builder-1.17[${PYTHON_USEDEP}]
			>=dev-python/sip-6.9:=[${PYTHON_USEDEP}]
		')
	)
"

src_configure() {
	QHEXEDIT_DESTDIR="${S}" eqmake6 src/qhexedit.pro

	if use gui; then
		pushd example || die "can't pushd example"
		eqmake6 qhexedit.pro
	fi
}

src_compile() {
	emake
	use gui && emake -C example
	if use python; then
		export PATH="$(qt6_get_bindir):${PATH}"
		python_build() {
			local build_dir="${BUILD_DIR}/python-build"
			mkdir -p "${build_dir}" || die
			cp -r "${S}"/src "${build_dir}/" || die
			cp "${S}"/license.txt "${build_dir}/" || die
			cp "${S}"/readme.md "${build_dir}/" || die
			cp "${S}"/python/pyqt6-pyproject.toml "${build_dir}/pyproject.toml" || die
			cp "${S}"/python/QHexEdit.sip "${build_dir}/" || die
			pushd "${build_dir}" || die
			# sip-build is not able to handle CFLAGS, CXXFLAGS and LDFLAGS
			# so we need to pass them as QMAKE_CFLAGS, QMAKE_CXXFLAGS and QMAKE_LFLAGS
			# https://bugs.gentoo.org/952787
			# https://bugs.gentoo.org/955165
			sip-build \
				--qmake-setting "QMAKE_CFLAGS += ${CFLAGS}" \
				--qmake-setting "QMAKE_CXXFLAGS += ${CXXFLAGS}" \
				--qmake-setting "QMAKE_LFLAGS += ${LDFLAGS}" \
				|| die
			popd || die
		}
		python_foreach_impl run_in_build_dir python_build
	fi
}

src_test() {
	pushd test || die "can't pushd test"
	mkdir logs || die "can't create logs dir"
	eqmake6 chunks.pro
	emake
	./chunks || die "test run failed"
	grep -q "^NOK" logs/Summary.log && die "test failed"
}

src_install() {
	doheader src/*.h
	dolib.so libqhexedit.so*
	if use python; then
		python_install() {
			pushd "${BUILD_DIR}"/python-build/build || die
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
		dodoc changelog.md
	fi
}
