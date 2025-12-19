# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic unpacker

DESCRIPTION="Revision Control System"
HOMEPAGE="https://www.gnu.org/software/rcs/"
SRC_URI="mirror://gnu/rcs/${P}.tar.lz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="doc"

RDEPEND="sys-apps/diffutils
	sys-apps/ed"
DEPEND="${RDEPEND}"
BDEPEND="$(unpacker_src_uri_depends)"

PATCHES=(
	"${FILESDIR}"/${PN}-5.10.1-configure-clang16.patch
	"${FILESDIR}"/${PN}-5.10.1-pointerfun.patch
)

src_prepare() {
	default

	sed -i -e '/gets is a security hole/d' \
		lib/stdio.in.h || die

	# Drop when clang 16 patch isn't needed anymore
	eautoreconf
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
		mv doc/rcs.html doc/html || die
		dodoc -r doc/html/
	fi
}
