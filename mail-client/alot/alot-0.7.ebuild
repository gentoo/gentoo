# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Experimental terminal UI for net-mail/notmuch written in Python"
HOMEPAGE="https://github.com/pazz/alot"
SRC_URI="https://github.com/pazz/alot/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
	"
RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/configobj-4.7.0[${PYTHON_USEDEP}]
	>=app-crypt/gpgme-1.9.0[python,${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-10.2.0[${PYTHON_USEDEP}]
	>=dev-python/urwid-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/urwidtrees-1.0[${PYTHON_USEDEP}]
	net-mail/mailbase
	>=net-mail/notmuch-0.13[crypt,python]
	"

python_prepare_all() {
	find "${S}" -name '*.py' -exec sed -e '1i# -*- coding: utf-8 -*-' -i '{}' +

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/alot
	doins -r extra
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		echo
		elog "If you are new to Alot you may want to take a look at"
		elog "the user manual:"
		elog "   https://alot.readthedocs.io/en/latest/"
		echo
	else
		local rv
		for rv in ${REPLACING_VERSIONS} ; do
			if [[ "0.3.2" == "${rv}" ]]; then
				ewarn ""
				ewarn "The syntax of theme-files and custom tags-sections of the config"
				ewarn "has been changed.  You have to revise your config.  There are"
				ewarn "converter scripts in /usr/share/alot/extra to help you out with"
				ewarn "this:"
				ewarn ""
				ewarn "  * tagsections_convert.py for your ~/.config/alot/config"
				ewarn "  * theme_convert.py to update your custom theme files"
				break;
			fi
			if [[ "0.5.1" == "${rv}" ]]; then
				ewarn ""
				ewarn "Since 0.6 version the GPG engine has switched to app-crypt/gpgme"
				ewarn "to use GPG signing operations, you can pass the key id has arg"
				ewarn "or setup the gpg_key value in your config file, see"
				ewarn "  https://alot.readthedocs.io/en/latest/usage/crypto.html?highlight=gpg"
				ewarn ""
				break;
			fi
		done
	fi
}
