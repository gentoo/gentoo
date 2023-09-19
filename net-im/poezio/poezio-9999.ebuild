# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature xdg

DESCRIPTION="Console XMPP client that looks like most famous IRC clients"
HOMEPAGE="https://poez.io/"
LICENSE="GPL-3+"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://lab.louiz.org/${PN}/${PN}.git"
	inherit git-r3

	# We build the html documentation using sphinx.
	BDEPEND="dev-python/sphinx"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/slixmpp-1.8.2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/Do-not-install-man-pages-and-files-in-usr-share-poez.patch"
)

distutils_enable_tests pytest

src_prepare() {
	default
	# Delete unmaintained plugin which requires an excessive external dep
	rm plugins/mpd_client.py || die
}

src_compile() {
	distutils-r1_src_compile

	if [[ -n "${EGIT_REPO_URI}" ]]; then
		emake -C doc html
	fi
}

# Poezio provides its own Python C extension 'poopt', which needs to be
# correctly discovered to run the tests. See
# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
python_test() {
	cd "${T}" || die
	epytest "${S}"/test
}

src_install() {
	distutils-r1_src_install

	doman data/poezio.1 data/poezio_logs.1

	if [[ -n "${EGIT_REPO_URI}" ]]; then
		docinto html
		dodoc -r doc/build/html/*
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "screen autoaway support" dev-python/pyinotify
}
