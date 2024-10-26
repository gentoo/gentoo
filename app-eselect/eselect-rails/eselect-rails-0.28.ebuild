# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages Ruby on Rails symlinks"
HOMEPAGE="https://gitweb.gentoo.org/proj/ruby-scripts.git/tree/eselect-rails"
SRC_URI="https://dev.gentoo.org/~graaff/ruby-team/${P}.tar.xz"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND=">=app-admin/eselect-1.2.0"

src_prepare() {
	default

	# Fix/Add Prefix support
	sed -i -e 's/\${ROOT}/${EROOT}/' *.eselect || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins *.eselect
}
