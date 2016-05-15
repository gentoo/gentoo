# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A terminal anywhere"
HOMEPAGE="http://anyterm.org/"
SRC_URI="http://anyterm.org/download/${P}.tbz2"

LICENSE="GPL-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/ssh"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.34.1"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.28-respect-LDFLAGS.patch"
	"${FILESDIR}/${P}-gcc-4.4.patch"
	"${FILESDIR}/${P}-boost-1.50.patch"
)

src_prepare() {
	default

	# Fix underlinking issue caused by recent boost versions
	# depending on boost::system, Gentoo bug #579522
	sed -e 's/\($(CXX) -o $@ $(LDFLAGS) $(OBJS) $(BLOBS) $(LINK_FLAGS)\)/\1 -lboost_system/' \
		-i common.mk || die
}

src_compile() {
	# this package uses `ld -r -b binary` and thus resulting executable contains
	# executable stack
	append-ldflags -Wl,-z,noexecstack
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	dosbin anytermd
	dodoc CHANGELOG README
	doman anytermd.1
	newinitd "${FILESDIR}/anyterm.init.d" anyterm
	newconfd "${FILESDIR}/anyterm.conf.d" anyterm
}

pkg_postinst() {
	elog "To proceed with installation, read the following:"
	elog "http://anyterm.org/1.1/install.html"
}
