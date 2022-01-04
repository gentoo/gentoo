# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit bash-completion-r1 cmake

DESCRIPTION="Taskwarrior is a command-line todo list manager"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${PV}/${P}.tar.gz
	https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${PV}/tests-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="+sync"

DEPEND="
	sync? ( net-libs/gnutls )
"
RDEPEND="${DEPEND}"

src_prepare() {
	# move test directory into source directory
	mv "${WORKDIR}"/test "${WORKDIR}"/${P} || die

	cmake_src_prepare

	# don't automatically install scripts
	sed -i '/scripts/d' CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		-DENABLE_SYNC=$(usex sync)
		-DTASK_DOCDIR=share/doc/${PF}
		-DTASK_RCDIR=share/${PN}/rc
	)

	cmake_src_configure
}

src_test() {
	cd "${WORKDIR}"/"${P}"_build || die

	emake test
}

src_install() {
	cmake_src_install

	newbashcomp scripts/bash/task.sh task

	# vim syntax
	rm scripts/vim/README || die
	insinto /usr/share/vim/vimfiles
	doins -r scripts/vim/*

	# zsh-completions
	insinto /usr/share/zsh/site-functions
	doins scripts/zsh/*

	exeinto "/usr/share/${PN}/scripts"
	doexe scripts/add-ons/*
}
