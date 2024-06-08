# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools toolchain-funcs

DESCRIPTION="networked mud that can be used for different types of collaborative software"
HOMEPAGE="https://sourceforge.net/projects/lambdamoo/"
SRC_URI="https://downloads.sourceforge.net/lambdamoo/LambdaMOO-${PV}.tar.gz"
S=${WORKDIR}/MOO-${PV}

LICENSE="LambdaMOO GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND="app-alternatives/yacc"

PATCHES=(
	"${FILESDIR}/${PV}-enable-outbound.patch"
	"${FILESDIR}/${P}-C99-configure.patch"
	"${FILESDIR}/${P}-respect-cflags.patch"
)
src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DHAVE_MKFIFO=1"
}

src_install() {
	dosbin moo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	newinitd "${FILESDIR}"/lambdamoo.rc ${PN}
	newconfd "${FILESDIR}"/lambdamoo.conf ${PN}
}
