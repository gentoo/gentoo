# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1 readme.gentoo-r1

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-lang/go-1.5.1:="
RDEPEND=">=dev-vcs/git-1.7.3"

DOC_CONTENTS="You may want to add 'alias git=hub' to your .{csh,bash}rc"

# https://github.com/github/hub/issues/592
# https://github.com/github/hub/pull/1136	
PATCHES=( "${FILESDIR}"/"${P}"-bashcomp.patch )

src_compile() {
	./script/build || die
}

#src_test() {
#	./script/test || die
#}

src_install() {
	readme.gentoo_create_doc

	dobin hub

	doman man/${PN}.1
	dodoc README.md

	newbashcomp etc/${PN}.bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion _${PN}
}

pkg_postinst() {
	readme.gentoo_print_elog
}
