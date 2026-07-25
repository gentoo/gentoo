# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=no
PYPI_VERIFY_REPO=https://github.com/pypa/installer
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

WHEEL_NAME=$(pypi_wheel_name)
DESCRIPTION="A library for installing Python wheels"
HOMEPAGE="
	https://pypi.org/project/installer/
	https://github.com/pypa/installer/
	https://installer.readthedocs.io/en/latest/
"
SRC_URI+="
	$(pypi_wheel_url)
	verify-provenance? (
		$(pypi_provenance_url "${WHEEL_NAME}") -> ${WHEEL_NAME}.provenance
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	app-arch/unzip
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_unpack() {
	if use verify-provenance; then
		pypi_verify_provenance "${DISTDIR}/${WHEEL_NAME}"{,.provenance}
	fi

	pypi_src_unpack

	cp "${DISTDIR}/${WHEEL_NAME}" "${WHEEL_NAME}.zip" || die
	unpack "./${WHEEL_NAME}.zip"
}

python_compile() {
	python_domodule src/installer "${WORKDIR}"/*.dist-info
}

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.15*)
			EPYTEST_DESELECT+=(
				# extra warnings for os.path.commonprefix()
				tests/test_core.py::TestInstall::test_skips_pycache_and_warns
			)
			;;
	esac

	epytest
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
