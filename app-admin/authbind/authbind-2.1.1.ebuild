# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Bind sockets to privileged ports without root"
HOMEPAGE="https://www.chiark.greenend.org.uk/ucgi/~ian/git/authbind.git/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="virtual/awk"

PATCHES=(
	"${FILESDIR}/${P}-respect-flags.patch"
)

src_configure() {
	tc-export CC LD

	sed -i \
		-e "s|^prefix=.*|prefix=/usr|" \
		-e "s|^lib_dir=.*|lib_dir=\$(prefix)/$(get_libdir)|" \
		-e "s|^libexec_dir=.*|libexec_dir=\$(prefix)/libexec/authbind|" \
		-e "s|^SHARED_LDFLAGS=.*|SHARED_LDFLAGS=$(raw-ldflags)|" \
		Makefile || die "sed failed"

	sed -i \
		-e 's|/usr/lib|/usr/libexec|' \
		authbind-helper.8 || die "sed failed"
}

src_install() {
	dobin authbind
	doman authbind.1 authbind-helper.8

	local major=$(awk -F= '/MAJOR=/ { print $2 }' Makefile || die)
	ln -s libauthbind.so.* libauthbind.so.${major} || die
	dolib.so libauthbind.so*

	exeinto /usr/libexec/authbind
	exeopts -m4755
	doexe helper

	keepdir /etc/authbind/by{addr,port,uid}

	dodoc debian/changelog
}
