# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/mercurial-server/mercurial-server-1.2.ebuild,v 1.4 2012/12/26 23:17:35 ottxor Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils eutils user

if [[ "${PV}" = "9999" ]]; then
	inherit mercurial
	EHG_REPO_URI="http://hg.opensource.lshift.net/mercurial-server"
	KEYWORDS=""
else
	MY_P="${PN}_${PV}"
	SRC_URI="http://dev.lshift.net/paul/mercurial-server/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}.orig"
fi

DESCRIPTION="Mercurial authentication and authorization tools"
HOMEPAGE="http://www.lshift.net/mercurial-server.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="dev-vcs/mercurial"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

pkg_setup() {
	enewgroup hg
	enewuser hg -1 /bin/bash "/var/lib/${PN}" hg
}

src_prepare() {
	# remove useless makefile
	rm Makefile

	# fix installation paths
	sed -i -e "s|'init'|'share/${PN}/init'|" setup.py \
		|| die 'sed setup.py failed.'

	# fix documentation
	if [[ "${PV}" = "1.1" ]]; then
		epatch "${FILESDIR}/${P}_documentation.patch"
	fi
}

src_compile() {
	distutils_src_compile

	# build documentation
	if use doc; then
		xsltproc --nonet -o manual.html \
		/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl \
		doc/manual.docbook || die "xsltproc failed"
	fi
}

src_install() {
	distutils_src_install --install-scripts="/usr/share/${PN}"

	# install configuration files
	insinto "/etc/${PN}"
	doins -r src/init/conf/*
	keepdir /etc/mercurial-server/keys/{root,users}

	# install documentation
	if use doc; then
		dohtml manual.html
	fi

	# install hg home directory
	keepdir "/var/lib/${PN}"
	fowners hg:hg "/var/lib/${PN}"
	fperms 750 "/var/lib/${PN}"
}
