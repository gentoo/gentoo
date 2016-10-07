# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Bring your .bashrc, .vimrc, etc. from your local machine when you ssh"
HOMEPAGE="https://github.com/Russell91/sshrc"
SRC_URI="https://github.com/Russell91/sshrc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mosh"

RDEPEND="
	virtual/ssh:0=
	mosh? ( net-misc/mosh:0[client] )
"

src_install()
{
	dobin sshrc
	use mosh && dobin moshrc
}
