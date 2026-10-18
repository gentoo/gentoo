# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..14} )
PYTHON_REQ_USE="sqlite,ssl?"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 greadme systemd

DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
HOMEPAGE="https://github.com/OfflineIMAP/offlineimap3"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/OfflineIMAP/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/OfflineIMAP/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
SRC_URI+="
	https://github.com/OfflineIMAP/offlineimap3/commit/2dc91a853aebd65815b0aaa0066e7d4069673cd8.patch
		-> ${PN}-8.0.3-fix-interpolation-error.patch
"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc kerberos keyring ssl"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
	>=dev-python/imaplib2-3.5[${PYTHON_USEDEP}]
	dev-python/rfc6555[${PYTHON_USEDEP}]
	kerberos? ( dev-python/gssapi[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( app-text/asciidoc )
	test? (
		${RDEPEND}
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/OfflineIMAP/offlineimap3/pull/251
	"${DISTDIR}/${PN}"-8.0.3-fix-interpolation-error.patch
)

distutils_enable_tests pytest

src_prepare() {
	sed -i "/^__version__/ s/\"\(.*\)\"/\"${PV}\"/" offlineimap/__init__.py || die "Can not set version"
	mv test/credentials.conf.sample test/credentials.conf || die "Can not rename test credentials"
	rm test/tests/test_01_basic.py || die "Can not remove network tests"
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	use doc && emake -C docs man
}

src_install() {
	distutils-r1_src_install

	systemd_douserunit contrib/systemd/*.{service,timer}

	dodoc offlineimap.conf offlineimap.conf.minimal
	use doc && doman docs/{offlineimap.1,offlineimapui.7}

	greadme_stdin <<-EOF
		You will need to configure offlineimap by creating ~/.offlineimaprc
		Sample configurations are in /usr/share/doc/${PF}/

		If you connect via ssl/tls and don't use CA cert checking, it will
		display the server's cert fingerprint and require you to add it to the
		configuration file to be sure it connects to the same server every
		time. This serves to help fixing CVE-2010-4532 (offlineimap doesn't
		check SSL server certificate) in cases where you have no CA cert.
	EOF
}
