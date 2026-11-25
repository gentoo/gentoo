# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/michaelrsweet.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Simple C library for using TrueType and OpenType font files"
HOMEPAGE="https://www.msweet.org/ttf/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/michaelrsweet/ttf"
	inherit git-r3
else
	SRC_URI="
		https://github.com/michaelrsweet/ttf/releases/download/v${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/michaelrsweet/ttf/releases/download/v${PV}/${P}.tar.gz.sig )
	"

	KEYWORDS="~amd64"
fi

# TODO: extension
LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-michaelrsweet )"

src_prepare() {
	default

	# Build verbosely
	sed -i -e '/.SILENT:/d' Makefile.in || die

	# Fix docdir
	sed -i -e 's:/doc/ttf:/doc/${PF}:' Makefile.in || die

	# Respect CFLAGS
	sed -i -e 's:-g -Os::' configure.ac configure || die

	# We already default to >=2 in Gentoo, don't downgrade
	sed -i -e 's: -D_FORTIFY_SOURCE=2::' configure.ac configure || die
}

src_configure() {
	tc-export AR

	local myeconfargs=(
		# Doesn't use libtool, so have to pass manually
		--enable-shared
		--disable-static

		--with-dsoflags="${LDFLAGS}"
		--with-ldflags="${LDFLAGS}"
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake -Onone test
}

src_install() {
	default

	# We handle this elsewhere
	rm "${ED}"/usr/share/doc/${PF}/{NOTICE,LICENSE} || die
}
