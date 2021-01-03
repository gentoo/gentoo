# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="Console XMPP client that looks like most famous IRC clients"
HOMEPAGE="https://poez.io/"
LICENSE="ZLIB"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://lab.louiz.org/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64"
fi

RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/slixmpp-1.5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

DOC_CONTENTS="
Install these optional runtime dependencies for additional features.
* dev-python/pyinotify for screen autoaway plugin support.
"
DISABLE_AUTOFORMATTING=true

src_prepare() {
	default
	# Delete unmaintained plugin which requires an excessive external dep
	rm plugins/mpd_client.py || die
}

src_install() {
	distutils-r1_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
