# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1 optfeature xdg

DESCRIPTION="Console XMPP client that looks like most famous IRC clients"
HOMEPAGE="https://poez.io/"
LICENSE="ZLIB"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://lab.louiz.org/${PN}/${PN}.git"
	inherit git-r3

	# We build the html documentation using sphinx.
	BDEPEND="dev-python/sphinx"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/slixmpp-1.7.1[${PYTHON_USEDEP}]
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
