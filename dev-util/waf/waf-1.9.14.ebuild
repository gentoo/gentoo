# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 toolchain-funcs

DESCRIPTION="piece of software used to help building software projects"
HOMEPAGE="https://waf.io/"
SRC_URI="https://waf.io/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="${PYTHON_DEPS}"

DOCS="ChangeLog README.md DEVEL"

src_prepare() {
	rm -v waf || die

	default
}

src_configure() {
	${EPYTHON} ./waf-light configure
}

src_compile() {
	${EPYTHON} ./waf-light build
}

src_install() {
	default

	#point waf binary to waflib dir and strip payload
	sed -e "/INSTALL=/s:=.*:='${EROOT}usr':" \
		-e "/REVISION=/s:=.*:='${PR}':" \
		-e "s:/lib/:/$(get_libdir)/:" \
		-e "/^#\(==>\|BZ\|<==\)/d" \
		-i waf || die
	dobin waf

	insinto /usr/$(get_libdir)/${PN}3-${PV}-${PR}
	doins -r waflib

	if use examples ; then
		dodoc -r demos
	fi
}
