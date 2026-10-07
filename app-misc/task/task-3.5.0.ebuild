# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )
RUST_MIN_VER="1.91.1"

inherit cargo cmake eapi9-ver optfeature python-any-r1 shell-completion

LIB_COMMIT="86935551e0faa56ed14c52802a23280a593df338"

DESCRIPTION="Command-line todo list manager"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="
	https://github.com/GothenburgBitFactory/taskwarrior/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/GothenburgBitFactory/libshared/archive/${LIB_COMMIT}.tar.gz -> libshared-${LIB_COMMIT}.gh.tar.gz
	https://github.com/gentoo-crate-dist/taskwarrior/releases/download/v${PV}/taskwarrior-${PV}-crates.tar.xz
"

S="${WORKDIR}/taskwarrior-${PV}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD CDLA-Permissive-2.0 ISC MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/corrosion
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	rust_pkg_setup
	if use test; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	rm -r src/libshared || die
	mv "${WORKDIR}/libshared-${LIB_COMMIT}" src/libshared || die

	# don't automatically install scripts and LICENSE
	sed -i -e '/scripts/d' \
		-e 's/doc_FILES .*/doc_FILES AUTHORS ChangeLog README.md)/' \
		CMakeLists.txt || die

	# shell tests cd into tmpdir where `include default.theme` must resolve
	sed -i '/cd "\$bashtap_tmpdir"/a cp "$bashtap_org_pwd"/default.theme .' \
		test/bash_tap.sh || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSTEM_CORROSION=ON
		-DENABLE_TLS_NATIVE_ROOTS=ON
		-DTASK_DOCDIR="share/doc/${PF}"
		-DTASK_RCDIR="share/${PN}/rc"
		$(usev test -DPython_EXECUTABLE="${PYTHON}")
	)

	cargo_env cmake_src_configure
}

src_compile() {
	cargo_env cmake_src_compile

	if use test; then
		cargo_env cmake_src_compile test_runner
	fi
}

src_test() {
	cp doc/rc/default.theme "${BUILD_DIR}"/test/ || die

	cargo_env cmake_src_test
	cargo_src_test
}

src_install() {
	cargo_env cmake_src_install

	# Shell completions
	newbashcomp scripts/bash/task.sh task
	dofishcomp scripts/fish/*
	dozshcomp scripts/zsh/*

	# vim syntax
	rm scripts/vim/README || die "Unable to remove README from Vim files"
	insinto /usr/share/vim/vimfiles
	doins -r scripts/vim/*
}

pkg_postinst() {
	if ver_replacing -lt 3; then
		ewarn "Taskwarrior 3 has changed its task storage."
		ewarn "Upgrading from version 2 requires manual action."
		ewarn
		ewarn "The following command imports data from Taskwarrior 2"
		ewarn "and disables all hooks during import:"
		ewarn
		ewarn "task import-v2 rc.hooks=0"
		ewarn
		ewarn "Taskwarrior 2 .data files can be backed up or removed."
		ewarn "Refer to https://taskwarrior.org/docs/upgrade-3/ for details."
	fi

	optfeature "sync with a git repository (sync.git.*)" dev-vcs/git
}
