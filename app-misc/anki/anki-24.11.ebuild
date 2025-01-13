# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
declare -A GIT_CRATES=(
	[linkcheck]='https://github.com/ankitects/linkcheck;184b2ca50ed39ca43da13f0b830a463861adb9ca;linkcheck-%commit%'
	[percent-encoding-iri]='https://github.com/ankitects/rust-url;bb930b8d089f4d30d7d19c12e54e66191de47b88;rust-url-%commit%/percent_encoding'
)
RUST_MIN_VER="1.80.1"

inherit cargo desktop edo multiprocessing ninja-utils optfeature \
	python-single-r1 readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net/"

# Don't forget to update COMMITS if PV changes.
# Update [node_modules] to the most recent commit hash until ${PV}, that
# changed yarn.lock.
# Oftentimes this file does not change between releases. This versioning
# scheme prevents unnecessary downloads of the (sizeable) node_modules
# folder.
declare -A COMMITS=(
	[anki]="87ccd24efd0ea635558b1679614b6763e4f514eb"
	[ftl-core]="e1545f7f0ddeb617eeb1ca86e82862e552843578"
	[ftl-desktop]="e0f9724f75f6248f4e74558b25c3182d4f348bce"
	[node_modules]="67e7bf166027c4e9e0c5bb7fd778d38f44038512"
)
SRC_URI="
	https://github.com/ankitects/anki/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/ankitects/anki-core-i18n/archive/${COMMITS[ftl-core]}.tar.gz
	-> anki-core-i18n-${COMMITS[ftl-core]}.gh.tar.gz
	https://github.com/ankitects/anki-desktop-ftl/archive/${COMMITS[ftl-desktop]}.tar.gz
	-> anki-desktop-ftl-${COMMITS[ftl-desktop]}.gh.tar.gz
	https://git.sr.ht/~antecrescent/gentoo-files/blob/main/app-misc/anki/${P}-crates.tar.xz
	gui? ( https://git.sr.ht/~antecrescent/gentoo-files/blob/main/app-misc/anki/anki-node_modules-${COMMITS[node_modules]}.tar.xz )
"

PATCHES=(
	"${FILESDIR}"/24.06.3/ninja-gentoo-setup.patch
	"${FILESDIR}"/24.06.3/remove-yarn.patch
	"${FILESDIR}"/24.04.1/remove-mypy-protobuf.patch
	"${FILESDIR}"/24.04.1/revert-cert-store-hack.patch
	"${FILESDIR}"/23.12.1/ninja-rules-for-cargo.patch
	"${FILESDIR}"/23.12.1/remove-formatter-dep.patch
)

# How to get an up-to-date summary of runtime JS libs' licenses:
# ./node_modules/.bin/license-checker-rseidelsohn --production --excludePackages anki --summary
LICENSE="AGPL-3+ BSD public-domain gui? ( 0BSD CC-BY-4.0 GPL-3+ Unlicense )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 CC0-1.0 ISC MIT
	MPL-2.0 Unicode-3.0 Unicode-DFS-2016 ZLIB
"
# Manually added crate licenses
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc +gui test"
REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!gui? ( test ) !test? ( test )"

# Dependencies:
# Python: python/requirements.{anki,aqt}.in
# If ENABLE_QT5_COMPAT is set at runtime
# additionally depend on PyQt6[dbus,printsupport].
# Qt: qt/{aqt/{sound.py,qt/*.py},tools/build_ui.py}
# app-misc/certificates: The rust backend library is built against
# rustls-native-certs to use the native certificate store.

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
	doc? (
		$(python_gen_cond_dep '
			>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
			dev-python/sphinx-autoapi[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	gui? (
		${PYTHON_DEPS}
		app-alternatives/ninja
		app-arch/unzip
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
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

QA_FLAGS_IGNORED="usr/bin/anki-sync-server
	usr/lib/python.*/site-packages/anki/_rsbridge.so"

pkg_setup() {
	export PROTOC_BINARY="${BROOT}"/usr/bin/protoc
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	export ZSTD_SYS_USE_PKG_CONFIG=1

	if use gui; then
		python-single-r1_pkg_setup
		export NODE_BINARY="${BROOT}"/usr/bin/node
		export YARN_BINARY="${BROOT}"/usr/bin/yarn
		export OFFLINE_BUILD=1
		if ! use debug; then
			if tc-is-lto; then
				export RELEASE=2
			else
				export RELEASE=1
			fi
		fi
	fi
	rust_pkg_setup
}

src_prepare() {
	default
	rm -r ftl/{core,qt}-repo || die
	ln -s "${WORKDIR}"/anki-core-i18n-${COMMITS[ftl-core]} ftl/core-repo || die
	ln -s "${WORKDIR}"/anki-desktop-ftl-${COMMITS[ftl-desktop]} ftl/qt-repo || die

	mkdir out || die
	echo -e "${COMMITS[anki]:0:8}" > out/buildhash || die
	if use gui; then
		mv "${WORKDIR}"/node_modules out || die

		# Some parts of the runner build system expect to be in a git repository
		mkdir .git || die

		# Creating the pseudo venv early skips pip dependency checks in src_configure.
		mkdir -p out/pyenv/bin || die
		ln -s "${PYTHON}" out/pyenv/bin/python || die
		# TODO: ln -s "${BROOT}/usr/bin/protoc-gen-mypy" out/pyenv/bin || die
		if use doc; then
			ln -s "${BROOT}"/usr/bin/sphinx-apidoc out/pyenv/bin || die
			ln -s "${BROOT}"/usr/bin/sphinx-build out/pyenv/bin || die
		fi

		# Fix hardcoded runner location
		export CARGO_TARGET_DIR="${S}"/out/rust
		cbuild_dir="$(CHOST=${CBUILD:-${CHOST}} cargo_target_dir)"
		sed "s,rust/release,${cbuild_dir##*out/}," \
			-i build/ninja_gen/src/render.rs || die

		# Separate src_configure from runner build
		sed '/ConfigureBuild/d' -i build/ninja_gen/src/build.rs || die
	fi
}

_cbuild_cargo_build() {
	CHOST=${CBUILD:-${CHOST}} cargo_src_compile "${@}"
}

src_configure() {
	cargo_src_configure
	if use gui; then
		tc-env_build _cbuild_cargo_build -p configure
		cargo_env edo "${cbuild_dir}"/configure
	fi
}

src_compile() {
	if use gui; then
		MY_RUNNER="cargo_env edo ${cbuild_dir}/runner build -- $(get_NINJAOPTS)"
		unset cbuild_dir

		tc-env_build _cbuild_cargo_build -p runner
		${MY_RUNNER} wheels
		use doc && ${MY_RUNNER} python:sphinx
	else
		cargo_src_compile --package anki-sync-server
	fi
}

src_test() {
	ln -s "${BROOT}"/usr/bin/pytest out/pyenv/bin/pytest || die
	mkdir out/bin || die
	ln -s "${BROOT}"/usr/bin/cargo-nextest out/bin/cargo-nextest || die

	local nextest_opts=(
		cargo-verbose
		failure-output=immediate
		status-level=all
		test-threads=$(get_makeopts_jobs)
	)
	# cargo-nextest respects Cargo's CARGO_TERM_COLOR variable
	if [[ ! ${CARGO_TERM_COLOR} ]]; then
		[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && nextest_opts+=( color=never )
	fi

	nextest_opts=( ${nextest_opts[@]/#/--} )
	# Override hardcoded cargo-nextest options
	sed -i -e "s/\(cargo nextest run\).*\\$/\1 ${nextest_opts[*]} \\$/" \
		"${S}"/build/ninja_gen/src/cargo.rs || die

	local runner
	for runner in pytest rust_test vitest; do
		${MY_RUNNER} check:${runner}
	done
}

src_install() {
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
	if use gui; then
		pushd qt/bundle/lin > /dev/null || die
		doman anki.1
		doicon anki.{png,xpm}
		domenu anki.desktop
		insinto /usr/share/mime/packages
		doins anki.xml
		popd || die
		use doc && dodoc -r out/python/sphinx/html

		local w
		for w in out/wheels/*.whl; do
			unzip "${w}" -d out/wheels || die
		done
		python_domodule out/wheels/{anki,{,_}aqt,*.dist-info}
		printf "#!/usr/bin/python3\nimport sys;from aqt import run;sys.exit(run())" > runanki || die
		python_newscript runanki anki
	else
		cargo_src_install --path rslib/sync
	fi
}

pkg_postinst() {
	ver_test ${REPLACING_VERSIONS} -lt 24.06.3-r1 && local FORCE_PRINT_ELOG=1
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
