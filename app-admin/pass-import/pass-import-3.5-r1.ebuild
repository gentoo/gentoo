# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/roddhjav.asc
inherit distutils-r1 optfeature shell-completion verify-sig xdg-utils

DESCRIPTION="pass extension for importing data from most existing password managers"
HOMEPAGE="
	https://github.com/roddhjav/pass-import/
	https://pypi.org/project/pass-import/
"
# lacking test files in sdist
SRC_URI="
	https://github.com/roddhjav/pass-import/releases/download/v${PV}/${P}.tar.gz
	verify-sig? (
		https://github.com/roddhjav/pass-import/releases/download/v${PV}/${P}.tar.gz.asc
	)
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# defusedxml is optional, it falls back to builtin, but then it's
# automagic, so just always depend on it.
RDEPEND="
	app-admin/pass
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/pyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/zxcvbn[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		sys-apps/dbus
	)
	verify-sig? (
		sec-keys/openpgp-keys-roddhjav
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pass-import-3.5-dont-install-data.patch
	"${FILESDIR}"/pass-import-3.5-deal-with-zxcvbn-4.5.0-password-limit.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	xdg_environment_reset
	mkdir -p "${XDG_DATA_HOME}"/keyrings || die
	cp tests/assets/db/gnome-keyring.keyring "${XDG_DATA_HOME}"/keyrings/pass-import.keyring || die
}

python_test() {
	EPYTEST_DESELECT=(
		# Tries to touch system networkmanager
		tests/test_open.py::TestOpen::test_open_networkmanager

		# FIXME
		tests/imports/test_parse.py::TestParse::test_import_gnome_keyring
	)
	EPYTEST_IGNORE=()

	if ! has_version dev-python/pykeepass; then
		EPYTEST_DESELECT+=(
			tests/imports/test_parse.py::TestParse::test_import_keepass
		)
	fi

	if ! has_version dev-python/jsonpath-ng; then
		EPYTEST_IGNORE+=(
			tests/filters/test_filter_jsonpath.py
		)
	fi

	local dbus_params=(
		$(dbus-daemon --session --print-address --fork --print-pid)
	)
	local -x DBUS_SESSION_BUS_ADDRESS=${dbus_params[0]}

	epytest

	kill "${dbus_params[1]}" || die
}

src_install() {
	distutils-r1_src_install

	exeinto /usr/lib/password-store/extensions
	doexe import.bash

	doman share/man/man1/pass-import.1 share/man/man1/pimport.1
	dobashcomp share/bash-completion/completions/pimport

	# bug #767871
	insinto /etc/bash_completion.d
	doins share/bash-completion/completions/pass-import

	dozshcomp share/zsh/site-functions/_pass-import \
		share/zsh/site-functions/_pimport
}

pkg_postinst() {
	#optfeature "Lastpass cli based import/export" app-admin/lpass
	optfeature "Keepass import from KDBX file" dev-python/pykeepass
	optfeature "Gnome Keyring import" dev-python/secretstorage
	optfeature "AndOTP or Aegis encrypted import" dev-python/cryptography
	#optfeature "Detection of file decryption" dev-python/file-magic
	optfeature "Filter exports" dev-python/jsonpath-ng
}
