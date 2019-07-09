# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )
inherit readme.gentoo-r1 distutils-r1

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz
	test? ( https://dev.gentoo.org/~gokturk/distfiles/app-crypt/${PN}/${PN}-0.7.1-test-files.tar.xz )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/fido2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	sys-auth/ykpers
"
DEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2_7')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-fix-tests.patch
)

python_test() {
	touch "${S}"/test/__init__.py || die
	cp -r "${WORKDIR}/files" "${S}"/test/ || die
	esetup.py test
}

python_install_all() {
	local DOC_CONTENTS

	distutils-r1_python_install_all

	DOC_CONTENTS="
		The 'openpgp' command may require the package 'app-crypt/ccid'
		to be installed on the system. Furthermore, make sure that pcscd
		daemon is running and has correct access permissions to USB
		devices.
	"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
