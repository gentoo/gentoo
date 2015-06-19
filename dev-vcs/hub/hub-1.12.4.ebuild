# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hub/hub-1.12.4.ebuild,v 1.1 2015/01/05 15:25:47 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"
RUBY_FAKEGEM_TASK_DOC=
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit bash-completion-r1 readme.gentoo ruby-fakegem

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RDEPEND+=" dev-vcs/git"

ruby_add_bdepend "
	test? (
		dev-ruby/webmock
		dev-util/cucumber
		dev-ruby/minitest:5
	)"

DOC_CONTENTS="You may want to add 'alias git=hub' to your .{csh,bash}rc"

all_ruby_prepare() {
	# Git's manpage changed, so this test will fail
	sed -i -e '/test_help_custom_command/,+4 s/^/#/' test/hub_test.rb || die
}

src_install() {
	ruby-ng_src_install
	readme.gentoo_create_doc

	cd "${S}"/all/${P} || die

	doman man/${PN}.1

	insinto /usr/share/${PN}/
	doins -r git-hooks

	# Broken with autoloader
	# https://github.com/github/hub/issues/592
	#newbashcomp etc/hub.bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion ${PN}
}
