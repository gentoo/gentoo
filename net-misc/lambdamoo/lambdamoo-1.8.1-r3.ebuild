# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="networked mud that can be used for different types of collaborative software"
HOMEPAGE="https://sourceforge.net/projects/lambdamoo/"
SRC_URI="mirror://sourceforge/lambdamoo/LambdaMOO-${PV}.tar.gz"

LICENSE="LambdaMOO GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""

S=${WORKDIR}/MOO-${PV}

src_prepare() {
	default

	eapply "${FILESDIR}"/${PV}-enable-outbound.patch
	sed -i Makefile.in \
		-e '/ -o /s|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed Makefile.in"
	eautoreconf
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} \
		-DHAVE_MKFIFO=1"
}

src_install() {
	dosbin moo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	newinitd "${FILESDIR}"/lambdamoo.rc ${PN}
	newconfd "${FILESDIR}"/lambdamoo.conf ${PN}
}
