# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Stanford GraphBase"
HOMEPAGE="http://ftp.cs.stanford.edu/pub/sgb/"
SRC_URI="http://ftp.cs.stanford.edu/pub/sgb/sgb-${PV:0:4}-${PV:4:2}-${PV:6:2}.tar.gz"

LICENSE="mmix"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/tex-base"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/sgb-20030623-parallel-make-fix.patch
	"${FILESDIR}"/sgb-20030623-destdir.patch
)

src_compile() {
	local vars=(
		CFLAGS="${CFLAGS}"
		SGBDIR=/usr/share/${PN}
		INCLUDEDIR=/usr/include/sgb
		LIBDIR=/usr/$(get_libdir)
		BINDIR=/usr/bin
		#CWEBINPUTS=/usr/share/${PN}/cweb
		#LDFLAGS="${LDFLAGS}"
	)
	# bug #299028
	emake -j1 "${vars[@]}" lib demos tests
}

src_test() {
	emake tests
}

src_install() {
	local vars=(
		SGBDIR=/usr/share/${PN}
		INCLUDEDIR=/usr/include/sgb
		LIBDIR=/usr/$(get_libdir)
		BINDIR=/usr/bin
		CFLAGS="${CFLAGS}"
		# TODO: why are they commented out above?
		LDFLAGS="${LDFLAGS}"
		CWEBINPUTS=/usr/share/${PN}/cweb
	)
	emake DESTDIR="${D}" "${vars[@]}" install

	# we don't need no makefile
	rm "${D}"/usr/include/sgb/Makefile || die

	dodoc ERRATA README
}
