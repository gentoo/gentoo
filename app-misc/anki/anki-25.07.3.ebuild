# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

declare -A GIT_CRATES=(
	[linkcheck]='https://github.com/ankitects/linkcheck;184b2ca50ed39ca43da13f0b830a463861adb9ca;linkcheck-%commit%'
	[percent-encoding-iri]='https://github.com/ankitects/rust-url;bb930b8d089f4d30d7d19c12e54e66191de47b88;rust-url-%commit%/percent_encoding'
)
RUST_MIN_VER="1.85.0"

inherit cargo desktop distutils-r1 edo greadme multiprocessing ninja-utils \
	optfeature toolchain-funcs xdg

DESCRIPTION="Smart spaced repetition flashcard program"
HOMEPAGE="https://apps.ankiweb.net/"

declare -A COMMITS=(
	[anki]="65b5aefd0705463cb12e72e254f798f90c96e815"
	[ftl-core]="b90ef6f03c251eb336029ac7c5f551200d41273f"
	[ftl-desktop]="9aa63c335c61b30421d39cf43fd8e3975179059c"
)
SRC_URI="${CARGO_CRATE_URIS}
	https://github.com/ankitects/anki/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/ankitects/anki-core-i18n/archive/${COMMITS[ftl-core]}.tar.gz
	-> anki-core-i18n-${COMMITS[ftl-core]}.gh.tar.gz
	https://github.com/ankitects/anki-desktop-ftl/archive/${COMMITS[ftl-desktop]}.tar.gz
	-> anki-desktop-ftl-${COMMITS[ftl-desktop]}.gh.tar.gz
	https://github.com/gentoo-crate-dist/anki/releases/download/${PV/3/1}/${P/3/1}-crates.tar.xz
	gui? (
		https://home.cit.tum.de/~salu/distfiles/${P/3/1}-node_modules.tar.xz
	)
"
# How to get an up-to-date summary of runtime JS libs' licenses:
# ./node_modules/.bin/license-checker-rseidelsohn --production --excludePackages anki --summary
LICENSE="
	AGPL-3+ BSD public-domain
	gui? ( 0BSD BlueOak-1.0.0 CC-BY-3.0 CC-BY-4.0 PSF-2 )
"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 CC0-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 Unicode-3.0 Unlicense ZLIB
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

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
		${DISTUTILS_DEPS}
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

EPYTEST_PLUGINS=()
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

python_prepare() {
	ln -s "${PYTHON}" out/pyenv/bin/python || die
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
	UV_BINARY="${BROOT}"/bin/true \
	OFFLINE_BUILD=1
	if ! use debug; then
		if tc-is-lto; then
			local -x RELEASE=2
		else
			local -x RELEASE=1
		fi
	fi
	cargo_env edo "${cbuild_dir}"/configure
	unset cbuild_dir
}

src_configure() {
	cargo_gen_config
	cargo_src_configure
	use gui && distutils-r1_src_configure
}

python_compile() {
	tc-env_build _cbuild_cargo_build -p runner
	cargo_env eninja -f out/build.ninja pylib qt
	declare -A wheel_tags=(
		[pylib]="cp39-abi3-manylinux_2_36_x86_64"
		[qt]="py3-none-any"
	)
	local dir
	for dir in ${!wheel_tags[@]}; do
		pushd ${dir} > /dev/null || die
		local -x ANKI_WHEEL_TAG=${wheel_tags[${dir}]}
		distutils-r1_python_compile
		popd || die
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
	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"
	edo cargo nextest run $(usev !debug '--release') \
			--color always \
			--all-features \
			--tests \
			--no-fail-fast
	eninja -f out/build.ninja check_vitest
}

src_test() {
	local -x ANKI_TEST_MODE=1
	distutils-r1_src_test
}

python_install_all() {
	pushd qt/launcher/lin > /dev/null || die
	doman anki.1
	doicon anki.{png,xpm}
	domenu anki.desktop
	insinto /usr/share/mime/packages
	doins anki.xml
	popd || die
	distutils-r1_python_install_all
}

src_install() {
	greadme_stdin <<- EOF
	Anki's user manual is located online at https://docs.ankiweb.net/
	Anki's add-on developer manual is located online at https://addon-docs.ankiweb.net/
	EOF

	if use gui; then
		distutils-r1_src_install
	else
		cargo_src_install --path rslib/sync
	fi
}

pkg_preinst() {
	greadme_pkg_preinst
	use gui && xdg_pkg_preinst
}

pkg_postinst() {
	greadme_pkg_postinst
	if use gui; then
		xdg_pkg_postinst
		optfeature "LaTeX in cards" "app-text/texlive[extra] app-text/dvipng"
		optfeature "sound support" media-video/mpv media-video/mplayer
		optfeature "recording support" "media-sound/lame[frontend] dev-python/pyqt6[multimedia]"
		optfeature "faster database operations" dev-python/orjson
		optfeature "Vulkan driver" "media-libs/vulkan-loader dev-qt/qtbase:6[vulkan]
			dev-qt/qtdeclarative:6[vulkan] dev-qt/qtwebengine:6[vulkan]"

		einfo "You can customize the LaTeX header for your cards to fit your needs:"
		einfo "Notes > Manage Note Types > [select a note type] > Options"
	fi
}
