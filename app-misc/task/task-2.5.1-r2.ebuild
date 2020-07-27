# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake

DESCRIPTION="Taskwarrior is a command-line todo list manager"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="https://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="clang +sync vim-syntax zsh-completion"

BDEPEND="
	clang? (
		sys-devel/clang
	)
"

DEPEND="
	clang? ( sys-libs/libcxx )
	sync? ( net-libs/gnutls )
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/0001-TW-1778-Unicode-strings-are-truncated-in-task-descri.patch )

src_prepare() {
	cmake_src_prepare

	# don't automatically install scripts
	sed -i '/scripts/d' CMakeLists.txt || die
}

src_configure() {
	if use sync; then
		mycmakeargs=(
			-DENABLE_SYNC=$(usex sync)
			-DTASK_DOCDIR=share/doc/${PF}
			-DTASK_RCDIR=share/${PN}/rc
		)
	fi

	cmake_src_configure
}

src_install() {
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=release
	)

	cmake_src_install

	newbashcomp scripts/bash/task.sh task

	if use vim-syntax; then
		rm scripts/vim/README || die
		insinto /usr/share/vim/vimfiles
		doins -r scripts/vim/*
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins scripts/zsh/*
	fi

	exeinto "/usr/share/${PN}/scripts"
	doexe scripts/add-ons/*
}
