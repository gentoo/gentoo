# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages Ruby on Rails symlinks"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~graaff/ruby-team/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.0"

S=${WORKDIR}

src_prepare() {
	default

	# Fix/Add Prefix support
	sed -i -e 's/\${ROOT}/${EROOT}/' *.eselect || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins *.eselect
}
