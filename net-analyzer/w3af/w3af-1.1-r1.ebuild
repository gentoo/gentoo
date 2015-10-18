# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit multilib python-single-r1 versionator

MY_P=${PN}-"$(replace_version_separator 2 '-')"

DESCRIPTION="Web Application Attack and Audit Framework"
HOMEPAGE="http://w3af.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gtk"

RDEPEND="
	>=dev-python/fpconst-0.7.2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/nltk[${PYTHON_USEDEP}]
	dev-python/pybloomfiltermmap[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyPdf[${PYTHON_USEDEP}]
	dev-python/python-cluster[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/soappy[${PYTHON_USEDEP}]
	dev-python/pysvn[${PYTHON_USEDEP}]
	|| (
		net-analyzer/gnu-netcat
		net-analyzer/netcat
		net-analyzer/netcat6
		)
	>=net-analyzer/scapy-2
	gtk? (
		media-gfx/graphviz
		>dev-python/pygtk-2.0
		dev-python/pygtksourceview
		)"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}

src_prepare(){
	rm -r extlib/{cluster,fpconst-0.7.2,pyPdf,SOAPpy,yaml} || die
	sed -i 's,extlib.pyPdf.,,' core/data/parsers/pdfParser.py || die
	rm readme/{GPL,INSTALL} || die
	rm plugins/attack/payloads/code/netcat || die #bug 349780
	esvn_clean
}

src_install() {
	insinto /usr/$(get_libdir)/w3af
	doins -r core extlib locales plugins profiles scripts tools w3af_gui w3af_console
	fperms +x /usr/$(get_libdir)/w3af/w3af_{gui,console}
	dobin "${FILESDIR}"/w3af_console
	use gtk && dobin "${FILESDIR}"/w3af_gui
	#use flag doc is here because doc is bigger than 3 Mb
	if use doc ; then
		insinto /usr/share/doc/${PF}/
		doins -r readme/*
	fi
	python_fix_shebang "${ED}"usr/$(get_libdir)/${PN}
}
