# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

MY_P="wxGlade-${PV}"

DESCRIPTION="Glade-like GUI designer which can generate Python, Perl, C++ or XRC code"
HOMEPAGE="http://wxglade.sourceforge.net/"
SRC_URI="mirror://sourceforge/wxglade/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="dev-python/wxpython:2.8[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-wxversion.patch
	eapply_user
}

src_compile() {
	python_fix_shebang wxglade.py
}

src_install() {
	dodoc CHANGES.txt README.txt TODO.txt
	newicon icons/icon.xpm wxglade.xpm
	doman debian/wxglade.1
	dodoc -r docs
	rm -r debian docs || die

	python_moduleinto /usr/lib/wxglade
	python_domodule .
	dosym /usr/share/doc/${PF}/docs /usr/lib/wxglade/docs
	fperms 775 /usr/lib/wxglade/wxglade.py
	dosym ../lib/wxglade/wxglade.py /usr/bin/wxglade

	make_desktop_entry wxglade wxGlade wxglade "Development;GUIDesigner"
}
