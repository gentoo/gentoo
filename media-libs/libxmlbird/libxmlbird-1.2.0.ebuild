# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit python-any-r1 vala toolchain-funcs multilib eutils

DESCRIPTION="XML parser written in Vala"
HOMEPAGE="https://birdfont.org/xmlbird.php"
SRC_URI="https://birdfont.org/xmlbird-releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# The test build logic needs work.  Doesn't respect compiler settings.
RESTRICT="test"

src_prepare() {
	vala_src_prepare

	epatch "${FILESDIR}"/${PN}-1.2.0-verbose.patch
	epatch "${FILESDIR}"/${PN}-1.2.0-configure-valac.patch
	epatch "${FILESDIR}"/${PN}-1.2.0-libdir.patch

	sed -i \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):" \
		configure dodo.py || die
	sed -i \
		-e '/tests.build_tests/d' \
		build.py || die
}

v() {
	echo "$@"
	"$@" || die
}

src_configure() {
	v ./configure \
		--prefix "${EPREFIX}/usr" \
		--libdir "$(get_libdir)" \
		--valac "${VALAC}" \
		--cc "$(tc-getCC)" \
		--cflags "${CFLAGS} ${CPPFLAGS}" \
		--ldflags "${LDFLAGS}"
}

src_compile() {
	v ./build.py
}

src_install() {
	v ./install.py --dest "${D}"
	dodoc NEWS README.md
}
