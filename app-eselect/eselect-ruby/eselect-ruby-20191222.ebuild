# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manages multiple Ruby versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/Ruby"
SRC_URI="https://dev.gentoo.org/~graaff/ruby-team/ruby.eselect-${PVR}.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

S=${WORKDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/ruby.eselect-${PVR}" ruby.eselect
}
