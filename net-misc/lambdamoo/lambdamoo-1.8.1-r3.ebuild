# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools toolchain-funcs

DESCRIPTION="Networked mud that can be used for different types of collaborative software"
HOMEPAGE="https://sourceforge.net/projects/lambdamoo/"
SRC_URI="mirror://sourceforge/lambdamoo/LambdaMOO-${PV}.tar.gz"

LICENSE="LambdaMOO GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"

BDEPEND="sys-devel/bison"

S=${WORKDIR}/MOO-${PV}

PATCHES=(
	"${FILESDIR}"/${PV}-enable-outbound.patch
	# Fixes QA warnings about implicit definitions
	"${FILESDIR}"/${PV}-include-string.patch
	# Removes configure rule as EAPI 8 doesn't seem to like it
	"${FILESDIR}"/${PV}-fix-make.patch
)

src_prepare() {
	default

	sed -i Makefile.in \
		-e '/ -o /s|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed Makefile.in"
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
