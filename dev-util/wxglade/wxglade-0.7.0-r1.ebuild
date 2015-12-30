# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 vcs-snapshot

MY_P="wxGlade-${PV}"

DESCRIPTION="Glade-like GUI designer which can generate Python, Perl, C++ or XRC code"
HOMEPAGE="https://bitbucket.org/agriggio/wxglade"
SRC_URI="https://bitbucket.org/agriggio/wxglade/get/rel_${PV}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="python"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
		dev-python/wxpython:2.8[${PYTHON_USEDEP}]"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fixes-from-arch.patch
}

src_compile() {
	:
}

src_install() {
	dodoc CHANGES.txt README.txt TODO.txt
	newicon icons/icon.xpm wxglade.xpm

	dohtml -r "${S}"/docs/*

	rm -r "${S}"/docs || die

	python_moduleinto ${PN}
	python_domodule *

	dosym /usr/share/doc/${PF}/html "$(python_get_sitedir)"/${PN}/docs

	make_wrapper ${PN} "${EPYTHON} $(python_get_sitedir)/${PN}/${PN}.py"

	make_desktop_entry wxglade wxGlade wxglade "Development;GUIDesigner"
}
