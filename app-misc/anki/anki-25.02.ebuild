# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{11..13} )

declare -A GIT_CRATES=(
	[linkcheck]='https://github.com/ankitects/linkcheck;184b2ca50ed39ca43da13f0b830a463861adb9ca;linkcheck-%commit%'
	[percent-encoding-iri]='https://github.com/ankitects/rust-url;bb930b8d089f4d30d7d19c12e54e66191de47b88;rust-url-%commit%/percent_encoding'
)
RUST_MIN_VER="1.82.0"

inherit cargo desktop distutils-r1 eapi9-ver multiprocessing ninja-utils \
	optfeature readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net/"

declare -A COMMITS=(
	[anki]="038d85b1d9e1896e93a3e4a26f600c79ddc33611"
	[ftl-core]="0fe0162f4a18e8ef2fbac1d9a33af8e38cf7260e"
	[ftl-desktop]="17216b03db7249600542e388bd4ea124478400e5"
)
SRC_URI="${CARGO_CRATE_URIS}
	https://github.com/ankitects/anki/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/ankitects/anki-core-i18n/archive/${COMMITS[ftl-core]}.tar.gz
	-> anki-core-i18n-${COMMITS[ftl-core]}.gh.tar.gz
	https://github.com/ankitects/anki-desktop-ftl/archive/${COMMITS[ftl-desktop]}.tar.gz
	-> anki-desktop-ftl-${COMMITS[ftl-desktop]}.gh.tar.gz
	https://github.com/gentoo-crate-dist/anki/releases/download/${PV}/${P}-crates.tar.xz
	gui? (
	https://git.sr.ht/~antecrescent/gentoo-files/blob/main/app-misc/anki/${P}-node_modules.tar.xz
	)
"
# How to get an up-to-date summary of runtime JS libs' licenses:
# ./node_modules/.bin/license-checker-rseidelsohn --production --excludePackages anki --summary
LICENSE="AGPL-3+ BSD public-domain gui? ( 0BSD CC-BY-4.0 GPL-3+ )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 CC0-1.0 ISC MIT
	MPL-2.0 Unicode-3.0 Unicode-DFS-2016 Unlicense ZLIB
"
# Manually added crate licenses
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gui"
REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!gui? ( test ) !test? ( test )"

# Dependencies:
# Python: python/requirements.{anki,aqt}.in
# If ENABLE_QT5_COMPAT is set at runtime
# additionally depend on PyQt6[dbus,printsupport].
# Qt: qt/{aqt/{sound.py,qt/*.py},tools/build_ui.py}
# app-misc/certificates: The rust backend library is built against
# rustls-native-certs to use the native certificate store.
# No ${PYTHON_DEPS} in DEPEND despite external module because it doesn't link
# against libpython

DEPEND="
	>=app-arch/zstd-1.5.5:=
	dev-db/sqlite:3
"
GUI_RDEPEND="
	${PYTHON_DEPS}
	dev-qt/qtsvg:6
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		>=dev-python/pyqt6-6.6.1[gui,network,opengl,quick,webchannel,widgets,${PYTHON_USEDEP}]
		>=dev-python/pyqt6-sip-13.6.0[${PYTHON_USEDEP}]
		>=dev-python/pyqt6-webengine-6.6.0[widgets,${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/send2trash[${PYTHON_USEDEP}]
		dev-python/waitress[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	app-misc/ca-certificates
	gui? ( ${GUI_RDEPEND} )
"

BDEPEND="
	>=app-arch/zstd-1.5.5:=
	dev-libs/protobuf[protoc(+)]
	virtual/pkgconfig
	gui? (
		${PYTHON_DEPS}
		app-alternatives/ninja
		>=net-libs/nodejs-20.12.1
		sys-apps/yarn
		$(python_gen_cond_dep '
			dev-python/pyqt6[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		')
	)
	test? (
		${RDEPEND}
		app-text/dvipng
		app-text/texlive
		dev-libs/openssl
		dev-util/cargo-nextest
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]')
	)
"

distutils_enable_sphinx python/sphinx \
			dev-python/sphinx-autoapi \
			dev-python/sphinx-rtd-theme

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/24.06.3/remove-yarn.patch
	"${FILESDIR}"/24.04.1/remove-mypy-protobuf.patch
	"${FILESDIR}"/24.04.1/revert-cert-store-hack.patch
	"${FILESDIR}"/23.12.1/ninja-rules-for-cargo.patch
)

QA_FLAGS_IGNORED="usr/bin/anki-sync-server
	usr/lib/python.*/site-packages/anki/_rsbridge.so"

pkg_setup() {
	export PROTOC_BINARY="${BROOT}"/usr/bin/protoc
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	export ZSTD_SYS_USE_PKG_CONFIG=1
	rust_pkg_setup
	use gui && python-single-r1_pkg_setup
}

python_prepare_all() {
	mv "${WORKDIR}"/node_modules out || die

	# Expected files and directories
	mkdir .git out/env || die
	mkdir -p out/pyenv/bin || die
	ln -s "${PYTHON}" out/pyenv/bin/python || die

	if use doc; then
		sed "/^REPO_ROOT/s|=.*|= \"${S}\"|" -i python/sphinx/conf.py || die
	fi

	# Unpin Yarn
	sed -e '/"type": "module"/s/,//' \
		-e '/packageManager/d' -i package.json || die

	# Not running the black formatter on generated files saves a dependency
	sed '/subprocess/d' -i pylib/tools/hookslib.py || die

	# Fix hardcoded runner location
	export CARGO_TARGET_DIR="${S}"/out/rust
	cbuild_dir="$(CHOST=${CBUILD:-${CHOST}} cargo_target_dir)"
	sed "s,rust/release,${cbuild_dir##*out/}," \
		-i build/ninja_gen/src/render.rs || die
	# Separate src_configure from runner build
	sed '/ConfigureBuild/d' -i build/ninja_gen/src/build.rs || die
	distutils-r1_python_prepare_all
}

src_prepare() {
	default
	rm -r ftl/{core,qt}-repo || die
	ln -s "${WORKDIR}"/anki-core-i18n-${COMMITS[ftl-core]} ftl/core-repo || die
	ln -s "${WORKDIR}"/anki-desktop-ftl-${COMMITS[ftl-desktop]} ftl/qt-repo || die

	mkdir out || die
	echo -e "${COMMITS[anki]:0:8}" > out/buildhash || die

	# None of our ninja implementations are n2
	sed 's/which::which("n2").*/false,/' -i build/ninja_gen/src/build.rs || die

	use gui && distutils-r1_src_prepare
}

_cbuild_cargo_build() {
	CHOST=${CBUILD:-${CHOST}} cargo_src_compile "${@}"
}

python_configure_all() {
	tc-env_build _cbuild_cargo_build -p configure

	local -x NODE_BINARY="${BROOT}"/usr/bin/node \
	YARN_BINARY="${BROOT}"/usr/bin/yarn \
	OFFLINE_BUILD=1
	if ! use debug; then
		if tc-is-lto; then
			local -x RELEASE=2
		else
			local -x RELEASE=1
		fi
	fi
	cargo_env "${cbuild_dir}"/configure || die
	unset cbuild_dir
}

src_configure() {
	cargo_gen_config
	cargo_src_configure
	use gui && distutils-r1_src_configure
}

python_compile() {
	tc-env_build _cbuild_cargo_build -p runner
	cargo_env eninja -f out/build.ninja wheels
	local w
	for w in out/wheels/*.whl; do
		distutils_wheel_install "${BUILD_DIR}"/install ${w}
	done
}

src_compile() {
	if use gui; then
		distutils-r1_src_compile
	else
		cargo_src_compile -p anki-sync-server
	fi
}

python_test() {
	epytest qt
	epytest pylib
}

python_test_all() {
	local nextest_opts=(
		cargo-verbose
		failure-output=immediate
		status-level=all
		test-threads=$(get_makeopts_jobs)
	)
	if [[ ! ${CARGO_TERM_COLOR} ]]; then
		[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && nextest_opts+=( color=never )
	fi
	nextest_opts=( ${nextest_opts[@]/#/--} )
	cargo_env cargo nextest run ${nextest_opts[@]} || die

	eninja -f out/build.ninja check_vitest
}

src_test() {
	local -x ANKI_TEST_MODE=1
	distutils-r1_src_test
}

python_install_all() {
	local DOC_CONTENTS="Users with add-ons that still rely on Anki's Qt5 GUI
	can temporarily set the environment variable ENABLE_QT5_COMPAT to 1 to have
	Anki install the previous compatibility code. This option has additional
	runtime dependencies. Please take a look at this package's optional runtime
	features for a complete listing.
	\n\nENABLE_QT5_COMPAT may be removed in the future, so this is not a
	long-term solution.
	\n\nAnki's user manual is located online at https://docs.ankiweb.net/
	\nAnki's add-on developer manual is located online at
	https://addon-docs.ankiweb.net/"

	readme.gentoo_create_doc
	pushd qt/bundle/lin > /dev/null || die
	doman anki.1
	doicon anki.{png,xpm}
	domenu anki.desktop
	insinto /usr/share/mime/packages
	doins anki.xml
	popd || die
	python_newscript - anki <<-EOF
		#!${EPREFIX}/usr/bin/python
		import sys
		from aqt import run
		sys.exit(run())
	EOF
	distutils-r1_python_install_all
}

src_install() {
	if use gui; then
		distutils-r1_src_install
	else
		cargo_src_install --path rslib/sync
	fi
}

pkg_postinst() {
	ver_replacing -lt 24.06.3-r1 && local FORCE_PRINT_ELOG=1
	readme.gentoo_print_elog
	if use gui; then
		xdg_pkg_postinst
		optfeature "LaTeX in cards" "app-text/texlive[extra] app-text/dvipng"
		optfeature "sound support" media-video/mpv media-video/mplayer
		optfeature "recording support" "media-sound/lame[frontend] dev-python/pyqt6[multimedia]"
		optfeature "faster database operations" dev-python/orjson
		optfeature "compatibility with Qt5-dependent add-ons" dev-python/pyqt6[dbus,printsupport]
		optfeature "Vulkan driver" "media-libs/vulkan-loader dev-qt/qtbase:6[vulkan]
			dev-qt/qtdeclarative:6[vulkan] dev-qt/qtwebengine:6[vulkan]"

		einfo "You can customize the LaTeX header for your cards to fit your needs:"
		einfo "Notes > Manage Note Types > [select a note type] > Options"
	fi
}
