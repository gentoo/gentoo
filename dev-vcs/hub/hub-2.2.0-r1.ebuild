# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hub/hub-2.2.0-r1.ebuild,v 1.1 2015/07/08 04:43:16 vikraman Exp $

EAPI=5

inherit bash-completion-r1 readme.gentoo

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-lang/go-1.4:="
RDEPEND=">=dev-vcs/git-1.7.3"

DOC_CONTENTS="You may want to add 'alias git=hub' to your .{csh,bash}rc"

src_compile() {
	./script/build || die
}

src_install() {
	readme.gentoo_create_doc

	dobin hub

	doman man/${PN}.1
	dodoc README.md

	# Broken with autoloader
	# https://github.com/github/hub/issues/592
	# newbashcomp etc/${PN}.bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion _${PN}
}
