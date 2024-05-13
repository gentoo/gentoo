# Copyright 2016-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit bash-completion-r1 edo distutils-r1 flag-o-matic toolchain-funcs

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mesonbuild/meson"
	inherit ninja-utils git-r3

	BDEPEND="
		${NINJA_DEPEND}
		$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	"

else
	inherit verify-sig

	MY_PV=${PV/_/}
	MY_P=${P/_/}
	S=${WORKDIR}/${MY_P}

	SRC_URI="
		https://github.com/mesonbuild/meson/releases/download/${MY_PV}/${MY_P}.tar.gz
		verify-sig? ( https://github.com/mesonbuild/meson/releases/download/${MY_PV}/${MY_P}.tar.gz.asc )
		https://github.com/mesonbuild/meson/releases/download/${MY_PV}/meson-reference.3 -> meson-reference-${MY_PV}.3
	"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-jpakkane )"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jpakkane.gpg

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
fi

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
		app-alternatives/ninja
		dev-vcs/git
		sys-libs/zlib[static-libs(+)]
		virtual/pkgconfig
	)
"
RDEPEND="
	!<dev-build/muon-0.2.0-r2[man(-)]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-python-path.patch
)

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		git-r3_src_unpack
	else
		default
		use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.gz{,.asc}
	fi
}

python_prepare_all() {
	local disable_unittests=(
		# ASAN and sandbox both want control over LD_PRELOAD
		# https://bugs.gentoo.org/673016
		-e 's/test_generate_gir_with_address_sanitizer/_&/'

		# ASAN is unsupported on some targets
		# https://bugs.gentoo.org/692822
		-e 's/test_pch_with_address_sanitizer/_&/'
	)

	sed -i "${disable_unittests[@]}" unittests/*.py || die

	# Broken due to python2 script created by python_wrapper_setup
	rm -r "test cases/frameworks/1 boost" || die

	distutils-r1_python_prepare_all
}

python_check_deps() {
	if [[ ${PV} = *9999* ]]; then
		python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
	fi
}

python_configure_all() {
	if [[ ${PV} = *9999* ]]; then
		# We use the unsafe_yaml loader because strictyaml is not packaged. In
		# theory they produce the same results, but pyyaml is faster and
		# without safety checks.
		edo ./meson.py setup \
			--prefix "${EPREFIX}/usr" \
			-Dhtml=false \
			-Dunsafe_yaml=true \
			docs/ docs/builddir
	fi
}

python_compile_all() {
	if [[ ${PV} = *9999* ]]; then
		eninja -C docs/builddir
	fi
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
		# meson has its own tests for LTO support. We don't need to verify that
		# all tests work when they happen to use it. And in particular, this
		# breaks rust.
		filter-lto

		# remove unwanted python_wrapper_setup contents
		# We actually do want to non-error if python2 is installed and tested.
		remove="${T}/${EPYTHON}/bin:"
		PATH=${PATH/${remove}/}

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

		${EPYTHON} -u run_tests.py
	) || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/vim/vimfiles
	doins -r data/syntax-highlighting/vim/{ftdetect,indent,syntax}

	insinto /usr/share/zsh/site-functions
	doins data/shell-completions/zsh/_meson

	dobashcomp data/shell-completions/bash/meson

	if [[ ${PV} = *9999* ]]; then
		DESTDIR="${ED}" eninja -C docs/builddir install
	else
		newman "${DISTDIR}"/meson-reference-${PV}.3 meson-reference.3
	fi
}
