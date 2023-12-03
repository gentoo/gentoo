# Copyright 2016-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mesonbuild/meson"
	inherit git-r3
else
	inherit verify-sig

	MY_PV=${PV/_/}
	MY_P=${P/_/}
	S=${WORKDIR}/${MY_P}

	SRC_URI="
		https://github.com/mesonbuild/meson/releases/download/${MY_PV}/${MY_P}.tar.gz
		verify-sig? ( https://github.com/mesonbuild/meson/releases/download/${MY_PV}/${MY_P}.tar.gz.asc )
	"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-jpakkane )"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jpakkane.gpg

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
fi

inherit bash-completion-r1 distutils-r1 toolchain-funcs

DESCRIPTION="Open source build system"
HOMEPAGE="https://mesonbuild.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-libs/glib:2
		dev-libs/gobject-introspection
		dev-util/ninja
		dev-vcs/git
		sys-libs/zlib[static-libs(+)]
		virtual/pkgconfig
	)
"
RDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-python-path.patch

	# backport fix for broken configure_file()
	"${FILESDIR}"/0001-Only-convert-boolean-values-for-cmake-formats.patch
)

python_prepare_all() {
	local disable_unittests=(
		# ASAN and sandbox both want control over LD_PRELOAD
		# https://bugs.gentoo.org/673016
		-e 's/test_generate_gir_with_address_sanitizer/_&/'

		# ASAN is unsupported on some targets
		# https://bugs.gentoo.org/692822
		-e 's/test_pch_with_address_sanitizer/_&/'

		# https://github.com/mesonbuild/meson/issues/7203
		-e 's/test_templates/_&/'

		# Broken due to python2 wrapper
		-e 's/test_python_module/_&/'
	)

	sed -i "${disable_unittests[@]}" unittests/*.py || die

	# Broken due to python2 script created by python_wrapper_setup
	rm -r "test cases/frameworks/1 boost" || die

	distutils-r1_python_prepare_all
}

src_test() {
	tc-export PKG_CONFIG
	if ${PKG_CONFIG} --exists Qt5Core && ! ${PKG_CONFIG} --exists Qt5Gui; then
		ewarn "Found Qt5Core but not Qt5Gui; skipping tests"
	else
		distutils-r1_src_test
	fi
}

python_test() {
	(
		# test_meson_installed
		unset PYTHONDONTWRITEBYTECODE

		# https://bugs.gentoo.org/687792
		unset PKG_CONFIG

		# test_cross_file_system_paths
		unset XDG_DATA_HOME

		# 'test cases/unit/73 summary' expects 80 columns
		export COLUMNS=80

		# If JAVA_HOME is not set, meson looks for javac in PATH.
		# If javac is in /usr/bin, meson assumes /usr/include is a valid
		# JDK include path. Setting JAVA_HOME works around this broken
		# autodetection. If no JDK is installed, we should end up with an empty
		# value in JAVA_HOME, and the tests should get skipped.
		export JAVA_HOME=$(java-config -O 2>/dev/null)

		# Call python3 instead of EPYTHON to satisfy test_meson_uninstalled.
		python3 run_tests.py
	) || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/vim/vimfiles
	doins -r data/syntax-highlighting/vim/{ftdetect,indent,syntax}

	insinto /usr/share/zsh/site-functions
	doins data/shell-completions/zsh/_meson

	dobashcomp data/shell-completions/bash/meson
}
