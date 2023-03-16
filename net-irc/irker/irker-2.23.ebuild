# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="ssl"

inherit optfeature python-single-r1 systemd

DESCRIPTION="Submission tools for IRC notifications"
HOMEPAGE="http://www.catb.org/esr/irker/ https://gitlab.com/esr/irker"
SRC_URI="http://www.catb.org/esr/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 ~s390 sparc x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Dependency notes:
# NOTE: No pkgconfig dep here because of the systemd sed below
# NOTE: No need for asciidoc here as it's only used for the
# 'release' makefile target.
RDEPEND="${PYTHON_DEPS}"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	${PYTHON_DEPS}
"

DOCS=( NEWS README hacking.adoc security.adoc )
HTML_DOCS=( irkerd.html irkerhook.html )

src_prepare() {
	default

	# Rely on systemd eclass for systemd service install
	sed -e "/^SYSTEMDSYSTEMUNITDIR/d" -i Makefile || die "sed failed"

	# Prefix support
	sed -e "s|@EPREFIX@|${EPREFIX}|" "${FILESDIR}"/irkerd.service > "${WORKDIR}"/irkerd.service || die "sed failed"
}

src_install() {
	default

	python_doscript "${ED}"/usr/bin/irkerd
	# Not installed with the default Makefile
	python_doscript irk irkerhook.py

	newinitd "${FILESDIR}"/irkerd.initd irkerd
	newconfd "${FILESDIR}"/irkerd.confd irkerd

	systemd_dounit "${WORKDIR}"/irkerd.service

	docinto examples
	dodoc filter-example.py filter-test.py
}

pkg_postinst() {
	optfeature "SOCKS5 proxy support" dev-python/PySocks
}
