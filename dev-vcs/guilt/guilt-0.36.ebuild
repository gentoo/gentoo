# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A series of bash scripts which add a quilt-like interface to git"
HOMEPAGE="http://repo.or.cz/w/guilt.git"
SRC_URI="${HOMEPAGE}/snapshot/22d785dd24329170f66e7696da38b3e90e033d61.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

# Since we need to build the man pages anyway, I don't think it makes
# much sense to hide the HTML docs behind USE=doc.
RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	dev-lang/perl"

RESTRICT="test"

S="${WORKDIR}/${PN}-22d785d"

src_prepare() {
	default

	# The doc makefile tries to shell out to `git` for the version.
	sed -i Documentation/Makefile \
		-e "s/VERSION=.*/VERSION=${PV}/" \
		|| die 'failed to set VERSION in Documentation/Makefile'
}

src_compile() {
	emake -C Documentation all
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	dodoc Documentation/{Contributing,Features,HOWTO,Requirements}
	emake -C Documentation \
			  DESTDIR="${D}" \
			  PREFIX=/usr \
			  mandir=/usr/share/man \
			  htmldir="/usr/share/doc/${PF}/html" \
			  install install-html
}
