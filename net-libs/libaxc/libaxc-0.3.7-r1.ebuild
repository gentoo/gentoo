# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

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
	test? ( dev-util/cmocka )
	"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}
RESTRICT="!test? ( test )"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rm -R lib || die  # unbundle libsignal-protocol-c
	default
}

src_compile() {
	local make_args=(
		PREFIX=/usr

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"

		ARCH=
	)
	emake "${make_args[@]}"
}

src_test() {
	# TODO: Test failures seem to be ignored in the upstream Makefile?
	# e.g. https://github.com/gkdr/axc/blob/master/Makefile#L153
	emake CC="$(tc-getCC)" test
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr ARCH= install

	# Respect libdir other than /usr/lib, e.g. /usr/lib64
	local libdir="$(get_libdir)"
	if [[ ${libdir} != lib ]]; then
		mv "${ED}"/usr/{lib,${libdir}} || die
		sed "s|^libdir=.*|libdir=\${prefix}/${libdir}|" \
				-i "${ED}/usr/${libdir}/pkgconfig/libaxc.pc" || die
	fi

	einstalldocs

	if ! use static-libs ; then
		rm "${ED}/usr/${libdir}/libaxc.a" || die
	fi
}
