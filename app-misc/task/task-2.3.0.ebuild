# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/task/task-2.3.0.ebuild,v 1.2 2014/11/28 17:16:35 radhermit Exp $

EAPI=5

inherit eutils cmake-utils bash-completion-r1

DESCRIPTION="Taskwarrior is a command-line todo list manager"
HOMEPAGE="http://taskwarrior.org/"
SRC_URI="http://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="vim-syntax zsh-completion"

DEPEND="net-libs/gnutls
	sys-libs/readline
	elibc_glibc? ( sys-apps/util-linux )"
RDEPEND="${DEPEND}"

src_prepare() {
	# use the correct directory locations
	sed -i -e "s:/usr/local/bin:${EPREFIX}/usr/bin:" \
		scripts/add-ons/* || die

	# don't automatically install scripts
	sed -i -e '/scripts/d' CMakeLists.txt || die

	epatch "${FILESDIR}"/${P}-issue-1473-rcdir-fix.patch
}

src_configure() {
	mycmakeargs=(
		-DTASK_DOCDIR=share/doc/${PF}
		-DTASK_RCDIR=share/${PN}/rc
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newbashcomp scripts/bash/task.sh task

	if use vim-syntax ; then
		rm scripts/vim/README
		insinto /usr/share/vim/vimfiles
		doins -r scripts/vim/*
	fi

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins scripts/zsh/*
	fi

	exeinto /usr/share/${PN}/scripts
	doexe scripts/add-ons/*
}
