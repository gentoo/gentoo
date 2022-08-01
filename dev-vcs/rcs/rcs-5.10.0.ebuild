# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Revision Control System"
HOMEPAGE="https://www.gnu.org/software/rcs/"
SRC_URI="mirror://gnu/rcs/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="doc"

RDEPEND="
	sys-apps/diffutils
	sys-apps/ed"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-test-t808.patch
	"${FILESDIR}"/${P}-test-t632.patch
	"${FILESDIR}"/${P}-glibc-2.34.patch
)

src_prepare() {
	default

	sed -i -e '/gets is a security hole/d' \
		lib/stdio.in.h || die
}

src_configure() {
	append-flags -std=gnu99
	econf
}

src_test() {
	# Tests attempt to call rcs commands on /dev/null and /tmp.
	# https://bugs.gentoo.org/840173
	local -x SANDBOX_PREDICT=${SANDBOX_PREDICT}
	addpredict /
	default
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog NEWS README

	if use doc; then
		emake -C doc html
		rm -R "${ED}/usr/share/doc/rcs"
		mv doc/rcs.html doc/html
		dodoc -r doc/html/
	fi
}
