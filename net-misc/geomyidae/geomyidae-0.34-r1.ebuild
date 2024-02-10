# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A daemon to serve the gopher protocol"
HOMEPAGE="http://r-36.net/scm/geomyidae/"
SRC_URI="ftp://bitreich.org/releases/geomyidae/${PN}-v${PV}.tgz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	acct-group/gopherd
	acct-user/gopherd
"
DEPEND="${RDEPEND}"

src_prepare() {
	# enable verbose build
	# respect CFLAGS
	# remove /usr/lib from LDFLAGS, bug #731672
	sed -i \
		-e 's/@${CC}/${CC}/g' \
		-e '/CFLAGS/s/=/?=/' \
		-e '/GEOM_LDFLAGS/s:-L/usr/lib ::' \
		Makefile || die 'sed on Makefile failed'
	# fix path for pid file
	sed -i \
		-e 's:/var/run:/run:g' \
		rc.d/Gentoo.init.d || die

	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin ${PN}

	newinitd rc.d/Gentoo.init.d ${PN}
	newconfd rc.d/Gentoo.conf.d ${PN}

	insinto /var/gopher
	doins index.gph
	fowners -R root.gopherd /var/gopher
	fperms -R g=rX,o=rX /var/gopher

	doman ${PN}.8
	dodoc CGI README
}
