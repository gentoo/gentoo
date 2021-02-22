# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="axc-${PV}"
DESCRIPTION="Client library for libsignal-protocol-c"
HOMEPAGE="https://github.com/gkdr/axc"
SRC_URI="https://github.com/gkdr/axc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"  # not GPL-3+
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RDEPEND="
	dev-db/sqlite
	dev-libs/glib
	dev-libs/libgcrypt
	net-libs/libsignal-protocol-c
	"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cmocka )
	"

S="${WORKDIR}"/${MY_P}
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-so-symlinks.patch
)

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rm -R lib || die  # unbundle libsignal-protocol-c
	default
}

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	# Respect libdir other than /usr/lib, e.g. /usr/lib64
	local libdir="$(get_libdir)"
	if [[ ${libdir} != lib ]]; then
		mv "${D}"/usr/{lib,${libdir}} || die
		sed "s|^libdir=.*|libdir=\${prefix}/${libdir}|" \
				-i "${D}/usr/${libdir}/pkgconfig/libaxc.pc" || die
	fi

	einstalldocs

	if ! use static-libs ; then
		rm "${D}/usr/${libdir}/libaxc.a" || die
	fi
}

src_test() {
	emake -j1 test
}
