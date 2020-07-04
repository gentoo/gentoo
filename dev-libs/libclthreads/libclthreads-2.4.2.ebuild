# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="POSIX threads C++ access library"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/clthreads-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

S="${WORKDIR}/clthreads-${PV}"

DOCS=( AUTHORS )

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
)

src_compile() {
	cd "${S}"/source || die "Failed to cd to sources"
	tc-export CXX
	emake
}

src_install() {
	default

	cd "${S}"/source || die "Failed to cd to sources"
	emake PREFIX="${EPREFIX}/usr" INCDIR="include" LIBDIR="$(get_libdir)" DESTDIR="${ED}" install
}
