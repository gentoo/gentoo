# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

MY_P=${P/_}

DESCRIPTION="A fractal generator"
HOMEPAGE="https://www.fractint.org"
SRC_URI="https://www.fractint.org/ftp/old/linux/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXft"
#	x86? ( dev-lang/nasm )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/xfractint-20.04p09-ldflags.patch"
}

src_compile() {
	# Untested, any x86 archteam dev. is allowed to uncomment this.
	local myasm="foo"
#	use x86 && myasm="/usr/bin/nasm"
	emake CC="$(tc-getCC)" AS="${myasm}" OPT="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}/usr" STRIP="true" install
	newenvd "${FILESDIR}"/xfractint.envd 60xfractint
}

pkg_postinst() {
	elog "XFractInt requires the FRACTDIR variable to be set in order to start."
	elog "Please re-login or \`source /etc/profile\` to have this variable set."
}
