# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A daemon to serve the gopher protocol"
HOMEPAGE="http://r-36.net/scm/geomyidae/"
SRC_URI="ftp://bitreich.org/releases/geomyidae/${PN}-v${PV}.tar.gz"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="acct-group/gopherd"
DEPEND="dev-libs/libretls:0="
RDEPEND="
	${BDEPEND}
	${DEPEND}
	acct-user/gopherd
"

src_prepare() {
	# remove /usr/lib from LDFLAGS, bug #731672
	sed -i \
		-e '/GEOM_LDFLAGS/s:-L/usr/lib ::' \
		Makefile || die 'sed on Makefile failed'

	eapply_user
}

src_compile() {
	append-cflags -D_FILE_OFFSET_BITS=64 # bug 927733
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin ${PN}

	newinitd rc.d/Gentoo.init.d ${PN}
	newconfd rc.d/Gentoo.conf.d ${PN}

	insinto /var/gopher
	doins index.gph
	fowners -R root:gopherd /var/gopher
	fperms -R g=rX,o=rX /var/gopher

	doman ${PN}.8
	dodoc CGI.md README
}
