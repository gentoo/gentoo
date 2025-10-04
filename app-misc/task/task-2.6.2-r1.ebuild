# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit bash-completion-r1 cmake

DESCRIPTION="Taskwarrior is a command-line todo list manager"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${PV}/${P}.tar.gz
	https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${PV}/tests-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~x64-macos"
IUSE="+sync"

DEPEND="
	sync? ( net-libs/gnutls )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc15-cstdint-include.patch"
	"${FILESDIR}/${P}-cmake4.patch" # bug 951880, downstream
)

src_prepare() {
	# move test directory into source directory
	mv "${WORKDIR}"/test . || die

	cmake_src_prepare
	cmake_comment_add_subdirectory scripts # don't install scripts
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_SYNC=$(usex sync)
		-DTASK_DOCDIR=share/doc/${PF}
		-DTASK_RCDIR=share/${PN}/rc
	)

	cmake_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
		emake test
	popd > /dev/null || die
}

src_install() {
	cmake_src_install

	newbashcomp scripts/bash/task.sh task

	# vim syntax
	rm scripts/vim/README || die
	insinto /usr/share/vim/vimfiles
	doins -r scripts/vim/*

	# zsh-completions
	dozshcomp scripts/zsh/*

	# fish-completions
	dofishcomp scripts/fish/*

	exeinto "/usr/share/${PN}/scripts"
	doexe scripts/add-ons/*
}
